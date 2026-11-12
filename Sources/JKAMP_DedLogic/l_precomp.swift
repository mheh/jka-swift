import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/botlib/l_precomp.cpp:81
let MAX_DEFINEPARMS = 128 as Int32

/// Source: oracle/codemp/botlib/l_precomp.cpp:83
let DEFINEHASHING = 1 as Int32

/// Source: oracle/codemp/botlib/l_precomp.cpp:92
let DEFINEHASHSIZE = 1024 as Int32

/// Source: oracle/codemp/botlib/l_precomp.cpp:94
let TOKEN_HEAP_SIZE = 4096 as Int32

/// Source: oracle/codemp/botlib/l_precomp.cpp:96
public var numtokens: Int32 {
    get { world.variables.numtokens }
    set { world.variables.numtokens = newValue }
}

/// Source: oracle/codemp/botlib/l_precomp.cpp:105
public var globaldefines: Slots<Define?>? {
    get { world.variables.globaldefines }
    set { world.variables.globaldefines = newValue }
}

/// Source: oracle/codemp/botlib/l_precomp.cpp:109
public var addGlobalDefine: Bool {
    get { world.variables.addGlobalDefine }
    set { world.variables.addGlobalDefine = newValue }
}

/// Source: oracle/codemp/botlib/l_precomp.cpp:1708
let MAX_VALUES = 64 as Int32

/// Source: oracle/codemp/botlib/l_precomp.cpp:1709
let MAX_OPERATORS = 64 as Int32

/// Source: oracle/codemp/botlib/l_precomp.cpp:2535
/// Raven's table, a hand property of `EngineWorld`, by the HAND_VARS ruling.
public var directives: [DirectiveRow] {
    get { world.directives }
    set { world.directives = newValue }
}

/// Source: oracle/codemp/botlib/l_precomp.cpp:2648
/// Raven's table, a hand property of `EngineWorld`, by the HAND_VARS ruling.
public var dollardirectives: [DirectiveRow] {
    get { world.dollardirectives }
    set { world.dollardirectives = newValue }
}

/// Source: oracle/codemp/botlib/l_precomp.cpp:3185
let MAX_SOURCEFILES = 64 as Int32

/// Source: oracle/codemp/botlib/l_precomp.cpp:3187
public var sourceFiles: Slots<Source?> { world.storage.sourceFiles }

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:117
public func SourceError(_ source: Source, _ str: String, _ args: any JKAShared.FormatArg...) {
    var text = CharBuf(1024)

    strcpy(&text, JKAShared.format(str, args))
    botimport.runPrint(PRT_ERROR, "file %s, line %d: %s\n", source.scriptstack!.filename, source.scriptstack!.line, String(text))
} //end of the function SourceError

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:141
public func SourceWarning(_ source: Source, _ str: String, _ args: any JKAShared.FormatArg...) {
    var text = CharBuf(1024)

    strcpy(&text, JKAShared.format(str, args))
    botimport.runPrint(PRT_WARNING, "file %s, line %d: %s\n", source.scriptstack!.filename, source.scriptstack!.line, String(text))
} //end of the function ScriptWarning

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:165
public func PC_PushIndent(_ source: Source, _ type: Int32, _ skip: Int32) {
    let indent: Indent

    indent = Indent(GetMemory(Int32(Indent.byteCount))!)
    indent.type = type
    indent.script = source.scriptstack
    indent.skip = (skip != 0) ? 1 : 0
    source.skip += indent.skip
    indent.next = source.indentstack
    source.indentstack = indent
} //end of the function PC_PushIndent

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:183
public func PC_PopIndent(_ source: Source, _ type: inout Int32, _ skip: inout Int32) {
    type = 0
    skip = 0

    guard let indent = source.indentstack else { return }

    //must be an indent from the current script
    if source.indentstack!.script != source.scriptstack { return }

    type = indent.type
    skip = indent.skip
    source.indentstack = source.indentstack!.next
    source.skip -= indent.skip
    FreeMemory(indent.handle)
} //end of the function PC_PopIndent

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:208
public func PC_PushScript(_ source: Source, _ script: Script) {
    var s: Script?

    s = source.scriptstack
    while s != nil {
        if Q_stricmp(s!.filename, script.filename) == 0 {
            SourceError(source, "%s recursively included", script.filename)
            return
        } //end if
        s = s!.next
    } //end for
    //push the script on the script stack
    script.next = source.scriptstack
    source.scriptstack = script
} //end of the function PC_PushScript

//============================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:230
public func PC_InitTokenHeap() {
    /*
    int i;

    if (tokenheapinitialized) return;
    freetokens = NULL;
    for (i = 0; i < TOKEN_HEAP_SIZE; i++)
    {
        token_heap[i].next = freetokens;
        freetokens = &token_heap[i];
    } //end for
    tokenheapinitialized = qtrue;
    */
} //end of the function PC_InitTokenHeap

//============================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:251
public func PC_CopyToken(_ token: Token) -> Token? {
    let t: Token?

//	t = (token_t *) malloc(sizeof(token_t));
    t = GetMemory(Int32(Token.byteCount)).map { Token($0) }
//	t = freetokens;
    if t == nil {
        Com_Error(ERR_FATAL, "out of token space\n")
        return nil
    } //end if
//	freetokens = freetokens->next;
    t!.copy(from: token)
    t!.next = nil
    numtokens += 1
    return t
} //end of the function PC_CopyToken

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:279
public func PC_FreeToken(_ token: Token) {
    //free(token);
    FreeMemory(token.handle)
//	token->next = freetokens;
//	freetokens = token;
    numtokens -= 1
} //end of the function PC_FreeToken

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:293
public func PC_ReadSourceToken(_ source: Source, _ token: Token) -> Int32 {
    let t: Token?
    var script: Script?
    var type: Int32 = 0, skip: Int32 = 0

    //if there's no token already available
    while source.tokens == nil {
        //if there's a token to read from the script
        if PS_ReadToken(source.scriptstack!, token) != 0 { return 1 }
        //if at the end of the script
        if EndOfScript(source.scriptstack!) != 0 {
            //remove all indents of the script
            while source.indentstack != nil &&
                source.indentstack!.script == source.scriptstack {
                SourceWarning(source, "missing #endif")
                PC_PopIndent(source, &type, &skip)
            } //end if
        } //end if
        //if this was the initial script
        if source.scriptstack!.next == nil { return 0 }
        //remove the script and return to the last one
        script = source.scriptstack
        source.scriptstack = source.scriptstack!.next
        FreeScript(script!)
    } //end while
    //copy the already available token
    token.copy(from: source.tokens!)
    //free the read token
    t = source.tokens
    source.tokens = source.tokens!.next
    PC_FreeToken(t!)
    return 1
} //end of the function PC_ReadSourceToken

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:336
@discardableResult
public func PC_UnreadSourceToken(_ source: Source, _ token: Token) -> Int32 {
    let t: Token?

    t = PC_CopyToken(token)
    t!.next = source.tokens
    source.tokens = t
    return 1
} //end of the function PC_UnreadSourceToken

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:351
public func PC_ReadDefineParms(_ source: Source, _ define: Define, _ parms: inout [Token?], _ maxparms: Int32) -> Int32 {
    Token.scratch { token -> Int32 in
        var t: Token?, last: Token?
        var i: Int32, done: Int32, lastcomma: Int32, numparms: Int32, indent: Int32

        if PC_ReadSourceToken(source, token) == 0 {
            SourceError(source, "define %s missing parms", define.name!)
            return 0
        } //end if
        //
        if define.numparms > maxparms {
            SourceError(source, "define with more than %d parameters", maxparms)
            return 0
        } //end if
        //
        i = 0
        while i < define.numparms {
            parms[i] = nil
            i += 1
        }
        //if no leading "("
        if strcmp(token.string, "(") != 0 {
            PC_UnreadSourceToken(source, token)
            SourceError(source, "define %s missing parms", define.name!)
            return 0
        } //end if
        //read the define parameters
        done = 0
        numparms = 0
        indent = 0
        while done == 0 {
            if numparms >= maxparms {
                SourceError(source, "define %s with too many parms", define.name!)
                return 0
            } //end if
            if numparms >= define.numparms {
                SourceWarning(source, "define %s has too many parms", define.name!)
                return 0
            } //end if
            parms[numparms] = nil
            lastcomma = 1
            last = nil
            while done == 0 {
                //
                if PC_ReadSourceToken(source, token) == 0 {
                    SourceError(source, "define %s incomplete", define.name!)
                    return 0
                } //end if
                //
                if strcmp(token.string, ",") == 0 {
                    if indent <= 0 {
                        if lastcomma != 0 { SourceWarning(source, "too many comma's") }
                        lastcomma = 1
                        break
                    } //end if
                } //end if
                lastcomma = 0
                //
                if strcmp(token.string, "(") == 0 {
                    indent += 1
                    continue
                } //end if
                else if strcmp(token.string, ")") == 0 {
                    indent -= 1
                    if indent <= 0 {
                        if parms[define.numparms - 1] == nil {
                            SourceWarning(source, "too few define parms")
                        } //end if
                        done = 1
                        break
                    } //end if
                } //end if
                //
                if numparms < define.numparms {
                    //
                    t = PC_CopyToken(token)
                    t!.next = nil
                    if last != nil {
                        last!.next = t
                    } else {
                        parms[numparms] = t
                    }
                    last = t
                } //end if
            } //end while
            numparms += 1
        } //end for
        return 1
    }
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:450
public func PC_StringizeTokens(_ tokens: Token?, _ token: Token) -> Int32 {
    var t: Token?

    token.type = TT_STRING
    // AI: Raven stores NULL in the two pointers. The fields hold a byte offset, and the offset 0 is the bits of NULL.
    token.whitespace_p = 0
    token.endwhitespace_p = 0
    token.stringBuffer[0] = 0
    strcat(&token.stringBuffer, "\"")
    t = tokens
    while t != nil {
        strncat(&token.stringBuffer, t!.string, MAX_TOKEN - strlen(token.string))
        t = t!.next
    } //end for
    strncat(&token.stringBuffer, "\"", MAX_TOKEN - strlen(token.string))
    return 1
} //end of the function PC_StringizeTokens

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:472
public func PC_MergeTokens(_ t1: Token, _ t2: Token) -> Int32 {
    //merging of a name with a name or number
    if t1.type == TT_NAME && (t2.type == TT_NAME || t2.type == TT_NUMBER) {
        strcat(&t1.stringBuffer, t2.string)
        return 1
    } //end if
    //merging of two strings
    if t1.type == TT_STRING && t2.type == TT_STRING {
        //remove trailing double quote
        t1.stringBuffer[strlen(t1.string) - 1] = 0
        //concat without leading double quote
        strcat(&t1.stringBuffer, t2.stringBuffer[1...])
        return 1
    } //end if
    //FIXME: merging of two number of the same sub type
    return 0
} //end of the function PC_MergeTokens

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:516
public func PC_PrintDefineHashTable(_ definehash: Slots<Define?>) {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    var i: Int32
    var d: Define?

    i = 0
    while i < DEFINEHASHSIZE {
        Log_Write("%4d:", i)
        d = definehash[i]
        while d != nil {
            Log_Write(" %s", d!.name!)
            d = d!.hashnext
        } //end for
        Log_Write("\n")
        i += 1
    } //end for
} //end of the function PC_PrintDefineHashTable

/// Source: oracle/codemp/botlib/l_precomp.cpp:539
public func PC_NameHash(_ name: String) -> Int32 {
    let name = CharBuf(name)
    var hash: Int32, i: Int32

    hash = 0
    i = 0
    while name[i] != 0 {
        hash += name[i] * (119 + i)
        //hash += (name[i] << 7) + i;
        //hash += (name[i] << (i&15));
        i += 1
    } //end while
    hash = (hash ^ (hash >> 10) ^ (hash >> 20)) & (DEFINEHASHSIZE - 1)
    return hash
} //end of the function PC_NameHash

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:559
public func PC_AddDefineToHash(_ define: Define, _ definehash: Slots<Define?>) {
    var hash: Int32
    // Raven writes his own `definehash` parameter, so the body writes a local of the same name.
    var definehash = definehash


    if addGlobalDefine {
        definehash = globaldefines!
        define.flags |= DEFINE_GLOBAL
    }

    hash = PC_NameHash(define.name!)
    define.hashnext = definehash[hash]
    definehash[hash] = define

    if addGlobalDefine {
        define.globalnext = define.hashnext
    }
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:585
public func PC_FindHashedDefine(_ definehash: Slots<Define?>, _ name: String) -> Define? {
    var d: Define?
    var hash: Int32

    hash = PC_NameHash(name)
    d = definehash[hash]
    while d != nil {
        if strcmp(d!.name!, name) == 0 { return d }
        d = d!.hashnext
    } //end for
    return nil
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:604
public func PC_FindDefine(_ defines: Define, _ name: String) -> Define? {
    // Port-note: Every call of Raven's stands in an arm that `DEFINEHASHING` turns off, so it is dead.
    var d: Define?

    d = defines
    while d != nil {
        if strcmp(d!.name!, name) == 0 { return d }
        d = d!.next
    } //end for
    return nil
} //end of the function PC_FindDefine

//============================================================================
//
// Parameter:				-
// Returns:					number of the parm
//								if no parm found with the given name -1 is returned
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:621
public func PC_FindDefineParm(_ define: Define, _ name: String) -> Int32 {
    var p: Token?
    var i: Int32

    i = 0
    p = define.parms
    while p != nil {
        if strcmp(p!.string, name) == 0 { return i }
        i += 1
        p = p!.next
    } //end for
    return -1
} //end of the function PC_FindDefineParm

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:640
public func PC_FreeDefine(_ define: Define) {
    var t: Token?, next: Token?

    //free the define parameters
    t = define.parms
    while t != nil {
        next = t!.next
        PC_FreeToken(t!)
        t = next
    } //end for
    //free the define tokens
    t = define.tokens
    while t != nil {
        next = t!.next
        PC_FreeToken(t!)
        t = next
    } //end for
    //free the define
    FreeMemory(define.handle)
} //end of the function PC_FreeDefine

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:665
public func PC_AddBuiltinDefines(_ source: Source) {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    var i: Int32
    var define: Define
    // AI: Raven declares a local struct table with a `{ NULL, 0 }` end row. The table is a local array of labeled tuples, and the walk stops at its count.
    let builtin: [(string: String, mBuiltin: Int32)] = [ // bk001204 - brackets
        ("__LINE__", BUILTIN_LINE),
        ("__FILE__", BUILTIN_FILE),
        ("__DATE__", BUILTIN_DATE),
        ("__TIME__", BUILTIN_TIME),
//		{ "__STDC__", BUILTIN_STDC },
    ]

    i = 0
    while i < builtin.count {
        // AI: Raven points the name at the bytes after the record. The setter keeps the text in the string pool, so those bytes stay unused.
        define = Define(GetMemory(Int32(Define.byteCount) + strlen(builtin[i].string) + 1)!)
        define.clear()
        define.name = builtin[i].string
        define.flags |= DEFINE_FIXED
        define.builtin = builtin[i].mBuiltin
        //add the define to the source
        PC_AddDefineToHash(define, source.definehash!)
        i += 1
    } //end for
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:705
public func PC_ExpandBuiltinDefine(_ source: Source, _ deftoken: Token, _ define: Define, _ firsttoken: inout Token?, _ lasttoken: inout Token?) -> Int32 {
    let token: Token
    var t: UInt32 //	time_t t; //to prevent LCC warning
    var curtime: CharBuf

    token = PC_CopyToken(deftoken)!
    switch define.builtin {
    case BUILTIN_LINE:
        strcpy(&token.stringBuffer, JKAShared.format("%d", [deftoken.line]))
        // C converts the `int` line to the `unsigned long` and the `double` at each store.
        token.intvalue = UInt32(bitPattern: deftoken.line)
        token.floatvalue = Double(deftoken.line)
        token.type = TT_NUMBER
        token.subtype = TT_DECIMAL | TT_INTEGER
        firsttoken = token
        lasttoken = token

    case BUILTIN_FILE:
        strcpy(&token.stringBuffer, source.scriptstack!.filename)
        token.type = TT_NAME
        token.subtype = strlen(token.string)
        firsttoken = token
        lasttoken = token

    case BUILTIN_DATE:
        t = SysBackend.time()
        curtime = CharBuf(SysBackend.ctime(t))
        strcpy(&token.stringBuffer, "\"")
        strncat(&token.stringBuffer, String(curtime[4...]), 7)
        // AI: Raven appends from `token->string+7`. The text holds no NUL before that offset, so the append from the start writes the same bytes.
        strncat(&token.stringBuffer, String(curtime[20...]), 4)
        strcat(&token.stringBuffer, "\"")
        // AI: Raven frees the static buffer of ctime, which C leaves undefined, rule 19. The free drops, because the text is a Swift value.
        token.type = TT_NAME
        token.subtype = strlen(token.string)
        firsttoken = token
        lasttoken = token

    case BUILTIN_TIME:
        t = SysBackend.time()
        curtime = CharBuf(SysBackend.ctime(t))
        strcpy(&token.stringBuffer, "\"")
        strncat(&token.stringBuffer, String(curtime[11...]), 8)
        strcat(&token.stringBuffer, "\"")
        // AI: Raven frees the static buffer of ctime, which C leaves undefined, rule 19. The free drops, because the text is a Swift value.
        token.type = TT_NAME
        token.subtype = strlen(token.string)
        firsttoken = token
        lasttoken = token

    default:
        firsttoken = nil
        lasttoken = nil
    } //end switch
    return 1
} //end of the function PC_ExpandBuiltinDefine

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:782
public func PC_ExpandDefine(_ source: Source, _ deftoken: Token, _ define: Define, _ firsttoken: inout Token?, _ lasttoken: inout Token?) -> Int32 {
    var parms = [Token?](repeating: nil, count: Int(MAX_DEFINEPARMS))
    var dt: Token?, pt: Token?, t: Token?
    var t1: Token?, t2: Token?, first: Token?, last: Token?, nextpt: Token?
    var parmnum: Int32, i: Int32

    //if it is a builtin define
    if define.builtin != 0 {
        return PC_ExpandBuiltinDefine(source, deftoken, define, &firsttoken, &lasttoken)
    } //end if
    //if the define has parameters
    if define.numparms != 0 {
        if PC_ReadDefineParms(source, define, &parms, MAX_DEFINEPARMS) == 0 { return 0 }
    } //end if
    //empty list at first
    first = nil
    last = nil
    //create a list with tokens of the expanded define
    dt = define.tokens
    while dt != nil {
        parmnum = -1
        //if the token is a name, it could be a define parameter
        if dt!.type == TT_NAME {
            parmnum = PC_FindDefineParm(define, dt!.string)
        } //end if
        //if it is a define parameter
        if parmnum >= 0 {
            pt = parms[parmnum]
            while pt != nil {
                t = PC_CopyToken(pt!)
                //add the token to the list
                t!.next = nil
                if last != nil { last!.next = t } else { first = t }
                last = t
                pt = pt!.next
            } //end for
        } //end if
        else {
            //if stringizing operator
            if dt!.stringBuffer[0] == Int32(ascii: "#") && dt!.stringBuffer[1] == 0 {
                //the stringizing operator must be followed by a define parameter
                if dt!.next != nil { parmnum = PC_FindDefineParm(define, dt!.next!.string) } else { parmnum = -1 }
                //
                if parmnum >= 0 {
                    //step over the stringizing operator
                    dt = dt!.next
                    //stringize the define parameter tokens
                    // Raven's record `token` serves only this arm, so the scratch covers the arm.
                    let stringized = Token.scratch { token -> Bool in
                        if PC_StringizeTokens(parms[parmnum], token) == 0 {
                            SourceError(source, "can't stringize tokens")
                            return false
                        } //end if
                        t = PC_CopyToken(token)
                        return true
                    }
                    if !stringized { return 0 }
                } //end if
                else {
                    SourceWarning(source, "stringizing operator without define parameter")
                    dt = dt!.next
                    continue
                } //end if
            } //end if
            else {
                t = PC_CopyToken(dt!)
            } //end else
            //add the token to the list
            t!.next = nil
            if last != nil { last!.next = t } else { first = t }
            last = t
        } //end else
        dt = dt!.next
    } //end for
    //check for the merging operator
    t = first
    while t != nil {
        if t!.next != nil {
            //if the merging operator
            if t!.next!.stringBuffer[0] == Int32(ascii: "#") && t!.next!.stringBuffer[1] == Int32(ascii: "#") {
                t1 = t
                t2 = t!.next!.next
                if t2 != nil {
                    if PC_MergeTokens(t1!, t2!) == 0 {
                        SourceError(source, "can't merge %s with %s", t1!.string, t2!.string)
                        return 0
                    } //end if
                    PC_FreeToken(t1!.next!)
                    t1!.next = t2!.next
                    if t2 == last { last = t1 }
                    PC_FreeToken(t2!)
                    continue
                } //end if
            } //end if
        } //end if
        t = t!.next
    } //end for
    //store the first and last token of the list
    firsttoken = first
    lasttoken = last
    //free all the parameter tokens
    i = 0
    while i < define.numparms {
        pt = parms[i]
        while pt != nil {
            nextpt = pt!.next
            PC_FreeToken(pt!)
            pt = nextpt
        } //end for
        i += 1
    } //end for
    //
    return 1
} //end of the function PC_ExpandDefine

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:920
public func PC_ExpandDefineIntoSource(_ source: Source, _ deftoken: Token, _ define: Define) -> Int32 {
    var firsttoken: Token?, lasttoken: Token?

    if PC_ExpandDefine(source, deftoken, define, &firsttoken, &lasttoken) == 0 { return 0 }

    if firsttoken != nil && lasttoken != nil {
        lasttoken!.next = source.tokens
        source.tokens = firsttoken
        return 1
    } //end if
    return 0
} //end of the function PC_ExpandDefineIntoSource

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:940
public func PC_ConvertPath(_ path: inout JKAShared.CharBuf) {
    var ptr: Int32

    //remove double path seperators
    ptr = 0
    while path[ptr] != 0 {
        if (path[ptr] == Int32(ascii: "\\") || path[ptr] == Int32(ascii: "/")) &&
            (path[ptr + 1] == Int32(ascii: "\\") || path[ptr + 1] == Int32(ascii: "/")) {
            // Port-note: Raven's strcpy copies between two pointers into one buffer, which C leaves undefined, rule 19.
            // The move reads the source bytes before it writes, the result his C library gives.
            memmove(&path, ptr + 1, strlen(path[(ptr + 1)...]) + 1, at: ptr)
        } //end if
        else {
            ptr += 1
        } //end else
    } //end while
    //set OS dependent path seperators
    ptr = 0
    while path[ptr] != 0 {
        // AI: Raven writes PATHSEPERATOR_CHAR of l_precomp.h. The body writes the hand PATH_SEP, the separator of the platform that builds.
        if path[ptr] == Int32(ascii: "/") || path[ptr] == Int32(ascii: "\\") { path[ptr] = PATH_SEP }
        ptr += 1
    } //end while
} //end of the function PC_ConvertPath

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:970
public func PC_Directive_include(_ source: Source) -> Int32 {
    return Token.scratch { token -> Int32 in
        var script: Script?
        var path = CharBuf(MAX_PATH)

        if source.skip > 0 { return 1 }
        //
        if PC_ReadSourceToken(source, token) == 0 {
            SourceError(source, "#include without file name")
            return 0
        } //end if
        if token.linescrossed > 0 {
            SourceError(source, "#include without file name")
            return 0
        } //end if
        if token.type == TT_STRING {
            StripDoubleQuotes(&token.stringBuffer)
            PC_ConvertPath(&token.stringBuffer)
            script = LoadScriptFile(token.string)
            if script == nil {
                strcpy(&path, source.includepath)
                strcat(&path, token.string)
                script = LoadScriptFile(String(path))
            } //end if
        } //end if
        else if token.type == TT_PUNCTUATION && token.stringBuffer[0] == Int32(ascii: "<") {
            strcpy(&path, source.includepath)
            while PC_ReadSourceToken(source, token) != 0 {
                if token.linescrossed > 0 {
                    PC_UnreadSourceToken(source, token)
                    break
                } //end if
                if token.type == TT_PUNCTUATION && token.stringBuffer[0] == Int32(ascii: ">") { break }
                strncat(&path, token.string, MAX_PATH)
            } //end while
            if token.stringBuffer[0] != Int32(ascii: ">") {
                SourceWarning(source, "#include missing trailing >")
            } //end if
            if strlen(path) == 0 {
                SourceError(source, "#include without file name between < >")
                return 0
            } //end if
            PC_ConvertPath(&path)
            script = LoadScriptFile(String(path))
        } //end if
        else {
            SourceError(source, "#include without file name")
            return 0
        } //end else
        if script == nil {
            SourceError(source, "file %s not found", path)
            return 0
        } //end if
        PC_PushScript(source, script!)
        return 1
    }
} //end of the function PC_Directive_include

//============================================================================
// reads a token from the current line, continues reading on the next
// line only if a backslash '\' is encountered.
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:1062
public func PC_ReadLine(_ source: Source, _ token: Token) -> Int32 {
    var crossline: Int32

    crossline = 0
    repeat {
        if PC_ReadSourceToken(source, token) == 0 { return 0 }

        if token.linescrossed > crossline {
            PC_UnreadSourceToken(source, token)
            return 0
        } //end if
        crossline = 1
    } while strcmp(token.string, "\\") == 0
    return 1
} //end of the function PC_ReadLine

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:1086
public func PC_WhiteSpaceBeforeToken(_ token: Token) -> Int32 {
    return (token.endwhitespace_p - token.whitespace_p > 0) ? 1 : 0
} //end of the function PC_WhiteSpaceBeforeToken

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:1096
public func PC_ClearTokenWhiteSpace(_ token: Token) {
    // AI: Raven stores NULL in the two pointers. The fields hold a byte offset, and the offset 0 is the bits of NULL.
    token.whitespace_p = 0
    token.endwhitespace_p = 0
    token.linescrossed = 0
} //end of the function PC_ClearTokenWhiteSpace

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:1108
public func PC_Directive_undef(_ source: Source) -> Int32 {
    return Token.scratch { token -> Int32 in
        var define: Define?, lastdefine: Define?
        var hash: Int32

        if source.skip > 0 { return 1 }
        //
        if PC_ReadLine(source, token) == 0 {
            SourceError(source, "undef without name")
            return 0
        } //end if
        if token.type != TT_NAME {
            PC_UnreadSourceToken(source, token)
            SourceError(source, "expected name, found %s", token.string)
            return 0
        } //end if

        hash = PC_NameHash(token.string)
        lastdefine = nil
        define = source.definehash![hash]
        while define != nil {
            if strcmp(define!.name!, token.string) == 0 {
                if (define!.flags & DEFINE_FIXED) != 0 {
                    SourceWarning(source, "can't undef %s", token.string)
                } //end if
                else {
                    if lastdefine != nil { lastdefine!.hashnext = define!.hashnext } else { source.definehash![hash] = define!.hashnext }

                    if (define!.flags & DEFINE_GLOBAL) == 0 {
                        PC_FreeDefine(define!)
                    }
                } //end else
                break
            } //end if
            lastdefine = define
            define = define!.hashnext
        } //end for
        return 1
    }
} //end of the function PC_Directive_undef

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:1180
public func PC_Directive_define(_ source: Source) -> Int32 {
    return Token.scratch { token -> Int32 in
        var t: Token?, last: Token?
        var define: Define?

        if source.skip > 0 { return 1 }
        //
        if PC_ReadLine(source, token) == 0 {
            SourceError(source, "#define without name")
            return 0
        } //end if
        if token.type != TT_NAME {
            PC_UnreadSourceToken(source, token)
            SourceError(source, "expected name after #define, found %s", token.string)
            return 0
        } //end if
        //check if the define already exists
        define = PC_FindHashedDefine(source.definehash!, token.string)
        if define != nil {
            if (define!.flags & DEFINE_FIXED) != 0 {
                SourceError(source, "can't redefine %s", token.string)
                return 0
            } //end if
            SourceWarning(source, "redefinition of %s", token.string)
            //unread the define name before executing the #undef directive
            PC_UnreadSourceToken(source, token)
            if PC_Directive_undef(source) == 0 { return 0 }
            //if the define was not removed (define->flags & DEFINE_FIXED)
            define = PC_FindHashedDefine(source.definehash!, token.string)
        } //end if
        //allocate define
        // AI: Raven points the name at the bytes after the record. The setter keeps the text in the string pool, so those bytes stay unused.
        define = Define(GetMemory(Int32(Define.byteCount) + strlen(token.string) + 1)!)
        define!.clear()
        define!.name = token.string
        //add the define to the source
        PC_AddDefineToHash(define!, source.definehash!)
        //if nothing is defined, just return
        if PC_ReadLine(source, token) == 0 { return 1 }
        //if it is a define with parameters
        if PC_WhiteSpaceBeforeToken(token) == 0 && strcmp(token.string, "(") == 0 {
            //read the define parameters
            last = nil
            if PC_CheckTokenString(source, ")") == 0 {
                while true {
                    if PC_ReadLine(source, token) == 0 {
                        SourceError(source, "expected define parameter")
                        return 0
                    } //end if
                    //if it isn't a name
                    if token.type != TT_NAME {
                        SourceError(source, "invalid define parameter")
                        return 0
                    } //end if
                    //
                    if PC_FindDefineParm(define!, token.string) >= 0 {
                        SourceError(source, "two the same define parameters")
                        return 0
                    } //end if
                    //add the define parm
                    t = PC_CopyToken(token)
                    PC_ClearTokenWhiteSpace(t!)
                    t!.next = nil
                    if last != nil { last!.next = t } else { define!.parms = t }
                    last = t
                    define!.numparms += 1
                    //read next token
                    if PC_ReadLine(source, token) == 0 {
                        SourceError(source, "define parameters not terminated")
                        return 0
                    } //end if
                    //
                    if strcmp(token.string, ")") == 0 { break }
                    //then it must be a comma
                    if strcmp(token.string, ",") != 0 {
                        SourceError(source, "define not terminated")
                        return 0
                    } //end if
                } //end while
            } //end if
            if PC_ReadLine(source, token) == 0 { return 1 }
        } //end if
        //read the defined stuff
        last = nil
        repeat {
            t = PC_CopyToken(token)
            if t!.type == TT_NAME && strcmp(t!.string, define!.name!) == 0 {
                SourceError(source, "recursive define (removed recursion)")
                continue
            } //end if
            PC_ClearTokenWhiteSpace(t!)
            t!.next = nil
            if last != nil { last!.next = t } else { define!.tokens = t }
            last = t
        } while PC_ReadLine(source, token) != 0
        //
        if last != nil {
            //check for merge operators at the beginning or end
            if strcmp(define!.tokens!.string, "##") == 0 ||
                strcmp(last!.string, "##") == 0 {
                SourceError(source, "define with misplaced ##")
                return 0
            } //end if
        } //end if
        return 1
    }
} //end of the function PC_Directive_define

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:1323
public func PC_DefineFromString(_ string: String) -> Define? {
    // Port-note: The two calls of Raven's stand in PC_AddDefine, which no file calls, and in an arm that `DEFINEHASHING` turns off, so it is dead.
    return Source.scratch { src -> Define? in
        let script: Script?
        var t: Token?
        let res: Int32
        var i: Int32
        var def: Define?

        PC_InitTokenHeap()

        script = LoadScriptMemory(string, strlen(string), "*extern")
        //create a new source
        src.clear()
        strncpy(&src.filenameBuffer, "*extern", MAX_PATH)
        src.scriptstack = script
        // The table holds `DEFINEHASHSIZE` record pointers, and `UInt.byteCount` is the size of one pointer.
        src.definehash = Slots(pointers: GetClearedMemory(DEFINEHASHSIZE * Int32(UInt.byteCount)), count: Int(DEFINEHASHSIZE))
        //create a define from the source
        res = PC_Directive_define(src)
        //free any tokens if left
        t = src.tokens
        while t != nil {
            src.tokens = src.tokens!.next
            PC_FreeToken(t!)
            t = src.tokens
        } //end for
        def = nil
        i = 0
        while i < DEFINEHASHSIZE {
            if src.definehash![i] != nil {
                def = src.definehash![i]
                break
            } //end if
            i += 1
        } //end for
        //
        FreeMemory(OpaquePointer(src.definehash!.base))
        //
        FreeScript(script!)
        //if the define was created succesfully
        if res > 0 { return def }
        //free the define is created
        if src.defines != nil { PC_FreeDefine(def!) }
        //
        return nil
    }
} //end of the function PC_DefineFromString

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:1381
public func PC_AddDefine(_ source: Source, _ string: String) -> Int32 {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    let define: Define?

    if addGlobalDefine {
        return PC_AddGlobalDefine(string)
    }

    define = PC_DefineFromString(string)
    if define == nil { return 0 }
    PC_AddDefineToHash(define!, source.definehash!)
    return 1
} //end of the function PC_AddDefine

//============================================================================
// add a globals define that will be added to all opened sources
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:1407
public func PC_AddGlobalDefine(_ string: String) -> Int32 {
    return 1
} //end of the function PC_AddGlobalDefine

//============================================================================
// remove the given global define
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:1426
public func PC_RemoveGlobalDefine(_ name: String) -> Int32 {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    return 0
} //end of the function PC_RemoveGlobalDefine

//============================================================================
// remove all globals defines
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:1447
public func PC_RemoveAllGlobalDefines() {
    var define: Define?

    var i: Int32
    if globaldefines != nil {
        i = 0
        while i < DEFINEHASHSIZE {
            while globaldefines![i] != nil {
                define = globaldefines![i]
                globaldefines![i] = globaldefines![i]!.globalnext
                PC_FreeDefine(define!)
            }
            i += 1
        }
    }
} //end of the function PC_RemoveAllGlobalDefines

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:1479
public func PC_CopyDefine(_ source: Source, _ define: Define) -> Define? {
    // Port-note: The one call of Raven's stands in an arm that `DEFINEHASHING` turns off, so it is dead.
    let newdefine: Define
    var token: Token?, newtoken: Token?, lasttoken: Token?

    newdefine = Define(GetMemory(Int32(Define.byteCount) + strlen(define.name!) + 1)!)
    //copy the define name
    // AI: Raven points the name at the bytes after the record. The setter keeps the text in the string pool, so those bytes stay unused.
    newdefine.name = define.name
    newdefine.flags = define.flags
    newdefine.builtin = define.builtin
    newdefine.numparms = define.numparms
    //the define is not linked
    newdefine.next = nil
    newdefine.hashnext = nil
    //copy the define tokens
    newdefine.tokens = nil
    lasttoken = nil
    token = define.tokens
    while token != nil {
        newtoken = PC_CopyToken(token!)
        newtoken!.next = nil
        if lasttoken != nil { lasttoken!.next = newtoken } else { newdefine.tokens = newtoken }
        lasttoken = newtoken
        token = token!.next
    } //end for
    //copy the define parameters
    newdefine.parms = nil
    lasttoken = nil
    token = define.parms
    while token != nil {
        newtoken = PC_CopyToken(token!)
        newtoken!.next = nil
        if lasttoken != nil { lasttoken!.next = newtoken } else { newdefine.parms = newtoken }
        lasttoken = newtoken
        token = token!.next
    } //end for
    return newdefine
} //end of the function PC_CopyDefine

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:1522
public func PC_AddGlobalDefinesToSource(_ source: Source) {
    var define: Define?

    var i: Int32
    i = 0
    while i < DEFINEHASHSIZE {
        define = globaldefines![i]
        while define != nil {
            define!.hashnext = nil
            PC_AddDefineToHash(define!, source.definehash!)

            define = define!.globalnext
        }
        i += 1
    }
} //end of the function PC_AddGlobalDefinesToSource

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:1558
public func PC_Directive_if_def(_ source: Source, _ type: Int32) -> Int32 {
    return Token.scratch { token -> Int32 in
        var d: Define?
        var skip: Int32

        if PC_ReadLine(source, token) == 0 {
            SourceError(source, "#ifdef without name")
            return 0
        } //end if
        if token.type != TT_NAME {
            PC_UnreadSourceToken(source, token)
            SourceError(source, "expected name after #ifdef, found %s", token.string)
            return 0
        } //end if
        d = PC_FindHashedDefine(source.definehash!, token.string)
        skip = ((type == INDENT_IFDEF) == (d == nil)) ? 1 : 0
        PC_PushIndent(source, type, skip)
        return 1
    }
} //end of the function PC_Directiveif_def

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:1590
public func PC_Directive_ifdef(_ source: Source) -> Int32 {
    return PC_Directive_if_def(source, INDENT_IFDEF)
} //end of the function PC_Directive_ifdef

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:1600
public func PC_Directive_ifndef(_ source: Source) -> Int32 {
    return PC_Directive_if_def(source, INDENT_IFNDEF)
} //end of the function PC_Directive_ifndef

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:1610
public func PC_Directive_else(_ source: Source) -> Int32 {
    var type: Int32 = 0, skip: Int32 = 0

    PC_PopIndent(source, &type, &skip)
    if type == 0 {
        SourceError(source, "misplaced #else")
        return 0
    } //end if
    if type == INDENT_ELSE {
        SourceError(source, "#else after #else")
        return 0
    } //end if
    PC_PushIndent(source, INDENT_ELSE, (skip == 0) ? 1 : 0)
    return 1
} //end of the function PC_Directive_else

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:1634
public func PC_Directive_endif(_ source: Source) -> Int32 {
    var type: Int32 = 0, skip: Int32 = 0

    PC_PopIndent(source, &type, &skip)
    if type == 0 {
        SourceError(source, "misplaced #endif")
        return 0
    } //end if
    return 1
} //end of the function PC_Directive_endif

/// Source: oracle/codemp/botlib/l_precomp.cpp:1668
public func PC_OperatorPriority(_ op: Int32) -> Int32 {
    switch op {
    case P_MUL: return 15
    case P_DIV: return 15
    case P_MOD: return 15
    case P_ADD: return 14
    case P_SUB: return 14

    case P_LOGIC_AND: return 7
    case P_LOGIC_OR: return 6
    case P_LOGIC_GEQ: return 12
    case P_LOGIC_LEQ: return 12
    case P_LOGIC_EQ: return 11
    case P_LOGIC_UNEQ: return 11

    case P_LOGIC_NOT: return 16
    case P_LOGIC_GREATER: return 12
    case P_LOGIC_LESS: return 12

    case P_RSHIFT: return 13
    case P_LSHIFT: return 13

    case P_BIN_AND: return 10
    case P_BIN_OR: return 8
    case P_BIN_XOR: return 9
    case P_BIN_NOT: return 16

    case P_COLON: return 5
    case P_QUESTIONMARK: return 5
    default: break
    } //end switch
    return 0
} //end of the function PC_OperatorPriority

/// Source: oracle/codemp/botlib/l_precomp.cpp:1730
public func PC_EvaluateTokens(_ source: Source, _ tokens: Token, _ intvalue: UnsafeMutablePointer<Int32>?, _ floatvalue: UnsafeMutablePointer<Double>?, _ integer: Int32) -> Int32 {
    // Raven's `operator_heap` and `value_heap` live to the end of the function, so the blocks are the closures.
    return Operator.scratch(count: Int(MAX_OPERATORS)) { operator_heap -> Int32 in
        Value.scratch(count: Int(MAX_VALUES)) { value_heap -> Int32 in
            var o: Operator?, firstoperator: Operator?, lastoperator: Operator?
            var v: Value?, firstvalue: Value?, lastvalue: Value?, v1: Value, v2: Value?
            var t: Token?
            var brace: Bool = false
            var parentheses: Int32 = 0
            var error: Int32 = 0
            var lastwasvalue: Int32 = 0
            var negativevalue: Int32 = 0
            var questmarkintvalue: Int32 = 0
            var questmarkfloatvalue: Double = 0
            var gotquestmarkvalue: Bool = false
            //
            var numoperators: Int32 = 0
            var numvalues: Int32 = 0

            lastoperator = nil
            firstoperator = lastoperator
            lastvalue = nil
            firstvalue = lastvalue
            if intvalue != nil { intvalue!.pointee = 0 }
            if floatvalue != nil { floatvalue!.pointee = 0 }
            t = tokens
            while t != nil {
                switch t!.type {
                case TT_NAME:
                    if lastwasvalue != 0 || negativevalue != 0 {
                        SourceError(source, "syntax error in #if/#elif")
                        error = 1
                        break
                    } //end if
                    if strcmp(t!.string, "defined") != 0 {
                        SourceError(source, "undefined name %s in #if/#elif", t!.string)
                        error = 1
                        break
                    } //end if
                    t = t!.next
                    if strcmp(t!.string, "(") == 0 {
                        brace = true
                        t = t!.next
                    } //end if
                    if t == nil || t!.type != TT_NAME {
                        SourceError(source, "defined without name in #if/#elif")
                        error = 1
                        break
                    } //end if
                    //v = (value_t *) GetClearedMemory(sizeof(value_t));
                    // AllocValue(v) of l_precomp.cpp:1710 expands here.
                    if numvalues >= MAX_VALUES {
                        SourceError(source, "out of value space\n")
                        error = 1
                        break
                    } else {
                        v = value_heap[numvalues]
                        numvalues += 1
                    }
                    if PC_FindHashedDefine(source.definehash!, t!.string) != nil {
                        v!.intvalue = 1
                        v!.floatvalue = 1
                    } //end if
                    else {
                        v!.intvalue = 0
                        v!.floatvalue = 0
                    } //end else
                    v!.parentheses = parentheses
                    v!.next = nil
                    v!.prev = lastvalue
                    if lastvalue != nil { lastvalue!.next = v } else { firstvalue = v }
                    lastvalue = v
                    if brace {
                        t = t!.next
                        if t == nil || strcmp(t!.string, ")") != 0 {
                            SourceError(source, "defined without ) in #if/#elif")
                            error = 1
                            break
                        } //end if
                    } //end if
                    brace = false
                    // defined() creates a value
                    lastwasvalue = 1

                case TT_NUMBER:
                    if lastwasvalue != 0 {
                        SourceError(source, "syntax error in #if/#elif")
                        error = 1
                        break
                    } //end if
                    //v = (value_t *) GetClearedMemory(sizeof(value_t));
                    // AllocValue(v) of l_precomp.cpp:1710 expands here.
                    if numvalues >= MAX_VALUES {
                        SourceError(source, "out of value space\n")
                        error = 1
                        break
                    } else {
                        v = value_heap[numvalues]
                        numvalues += 1
                    }
                    if negativevalue != 0 {
                        v!.intvalue = -Int32(bitPattern: t!.intvalue)
                        v!.floatvalue = -t!.floatvalue
                    } //end if
                    else {
                        // C converts the `unsigned long` to the `signed long` at the store, with the same bits.
                        v!.intvalue = Int32(bitPattern: t!.intvalue)
                        v!.floatvalue = t!.floatvalue
                    } //end else
                    v!.parentheses = parentheses
                    v!.next = nil
                    v!.prev = lastvalue
                    if lastvalue != nil { lastvalue!.next = v } else { firstvalue = v }
                    lastvalue = v
                    //last token was a value
                    lastwasvalue = 1
                    //
                    negativevalue = 0

                case TT_PUNCTUATION:
                    if negativevalue != 0 {
                        SourceError(source, "misplaced minus sign in #if/#elif")
                        error = 1
                        break
                    } //end if
                    if t!.subtype == P_PARENTHESESOPEN {
                        parentheses += 1
                        break
                    } //end if
                    else if t!.subtype == P_PARENTHESESCLOSE {
                        parentheses -= 1
                        if parentheses < 0 {
                            SourceError(source, "too many ) in #if/#elsif")
                            error = 1
                        } //end if
                        break
                    } //end else if
                    //check for invalid operators on floating point values
                    if integer == 0 {
                        if t!.subtype == P_BIN_NOT || t!.subtype == P_MOD ||
                            t!.subtype == P_RSHIFT || t!.subtype == P_LSHIFT ||
                            t!.subtype == P_BIN_AND || t!.subtype == P_BIN_OR ||
                            t!.subtype == P_BIN_XOR {
                            SourceError(source, "illigal operator %s on floating point operands\n", t!.string)
                            error = 1
                            break
                        } //end if
                    } //end if
                    switch t!.subtype {
                    case P_LOGIC_NOT, P_BIN_NOT:
                        if lastwasvalue != 0 {
                            SourceError(source, "! or ~ after value in #if/#elif")
                            error = 1
                            break
                        } //end if

                    case P_INC, P_DEC:
                        SourceError(source, "++ or -- used in #if/#elif")

                    case P_SUB:
                        if lastwasvalue == 0 {
                            negativevalue = 1
                            break
                        } //end if
                        fallthrough

                    case P_MUL, P_DIV, P_MOD, P_ADD,
                         P_LOGIC_AND, P_LOGIC_OR, P_LOGIC_GEQ, P_LOGIC_LEQ, P_LOGIC_EQ, P_LOGIC_UNEQ,
                         P_LOGIC_GREATER, P_LOGIC_LESS,
                         P_RSHIFT, P_LSHIFT,
                         P_BIN_AND, P_BIN_OR, P_BIN_XOR,
                         P_COLON, P_QUESTIONMARK:
                        if lastwasvalue == 0 {
                            SourceError(source, "operator %s after operator in #if/#elif", t!.string)
                            error = 1
                            break
                        } //end if

                    default:
                        SourceError(source, "invalid operator %s in #if/#elif", t!.string)
                        error = 1
                    } //end switch
                    if error == 0 && negativevalue == 0 {
                        //o = (operator_t *) GetClearedMemory(sizeof(operator_t));
                        // AllocOperator(o) of l_precomp.cpp:1720 expands here.
                        if numoperators >= MAX_OPERATORS {
                            SourceError(source, "out of operator space\n")
                            error = 1
                            break
                        } else {
                            o = operator_heap[numoperators]
                            numoperators += 1
                        }
                        o!.mOperator = t!.subtype
                        o!.priority = PC_OperatorPriority(t!.subtype)
                        o!.parentheses = parentheses
                        o!.next = nil
                        o!.prev = lastoperator
                        if lastoperator != nil { lastoperator!.next = o } else { firstoperator = o }
                        lastoperator = o
                        lastwasvalue = 0
                    } //end if

                default:
                    SourceError(source, "unknown %s in #if/#elif", t!.string)
                    error = 1
                } //end switch
                if error != 0 { break }
                t = t!.next
            } //end for
            if error == 0 {
                if lastwasvalue == 0 {
                    SourceError(source, "trailing operator in #if/#elif")
                    error = 1
                } //end if
                else if parentheses != 0 {
                    SourceError(source, "too many ( in #if/#elif")
                    error = 1
                } //end else if
            } //end if
            //
            gotquestmarkvalue = false
            questmarkintvalue = 0
            questmarkfloatvalue = 0
            //while there are operators
            while error == 0 && firstoperator != nil {
                v = firstvalue
                o = firstoperator
                while o!.next != nil {
                    //if the current operator is nested deeper in parentheses
                    //than the next operator
                    if o!.parentheses > o!.next!.parentheses { break }
                    //if the current and next operator are nested equally deep in parentheses
                    if o!.parentheses == o!.next!.parentheses {
                        //if the priority of the current operator is equal or higher
                        //than the priority of the next operator
                        if o!.priority >= o!.next!.priority { break }
                    } //end if
                    //if the arity of the operator isn't equal to 1
                    if o!.mOperator != P_LOGIC_NOT && o!.mOperator != P_BIN_NOT { v = v!.next }
                    //if there's no value or no next value
                    if v == nil {
                        SourceError(source, "mising values in #if/#elif")
                        error = 1
                        break
                    } //end if
                    o = o!.next
                } //end for
                if error != 0 { break }
                v1 = v!
                v2 = v!.next
                switch o!.mOperator {
                case P_LOGIC_NOT:
                    v1.intvalue = v1.intvalue == 0 ? 1 : 0
                    v1.floatvalue = v1.floatvalue == 0 ? 1 : 0
                case P_BIN_NOT:
                    v1.intvalue = ~v1.intvalue
                case P_MUL:
                    v1.intvalue *= v2!.intvalue
                    v1.floatvalue *= v2!.floatvalue
                case P_DIV:
                    if v2!.intvalue == 0 || v2!.floatvalue == 0 {
                        SourceError(source, "divide by zero in #if/#elif\n")
                        error = 1
                        break
                    }
                    v1.intvalue /= v2!.intvalue
                    v1.floatvalue /= v2!.floatvalue
                case P_MOD:
                    if v2!.intvalue == 0 {
                        SourceError(source, "divide by zero in #if/#elif\n")
                        error = 1
                        break
                    }
                    v1.intvalue %= v2!.intvalue
                case P_ADD:
                    v1.intvalue += v2!.intvalue
                    v1.floatvalue += v2!.floatvalue
                case P_SUB:
                    v1.intvalue -= v2!.intvalue
                    v1.floatvalue -= v2!.floatvalue
                case P_LOGIC_AND:
                    v1.intvalue = (v1.intvalue != 0 && v2!.intvalue != 0) ? 1 : 0
                    v1.floatvalue = (v1.floatvalue != 0 && v2!.floatvalue != 0) ? 1 : 0
                case P_LOGIC_OR:
                    v1.intvalue = (v1.intvalue != 0 || v2!.intvalue != 0) ? 1 : 0
                    v1.floatvalue = (v1.floatvalue != 0 || v2!.floatvalue != 0) ? 1 : 0
                case P_LOGIC_GEQ:
                    v1.intvalue = v1.intvalue >= v2!.intvalue ? 1 : 0
                    v1.floatvalue = v1.floatvalue >= v2!.floatvalue ? 1 : 0
                case P_LOGIC_LEQ:
                    v1.intvalue = v1.intvalue <= v2!.intvalue ? 1 : 0
                    v1.floatvalue = v1.floatvalue <= v2!.floatvalue ? 1 : 0
                case P_LOGIC_EQ:
                    v1.intvalue = v1.intvalue == v2!.intvalue ? 1 : 0
                    v1.floatvalue = v1.floatvalue == v2!.floatvalue ? 1 : 0
                case P_LOGIC_UNEQ:
                    v1.intvalue = v1.intvalue != v2!.intvalue ? 1 : 0
                    v1.floatvalue = v1.floatvalue != v2!.floatvalue ? 1 : 0
                case P_LOGIC_GREATER:
                    v1.intvalue = v1.intvalue > v2!.intvalue ? 1 : 0
                    v1.floatvalue = v1.floatvalue > v2!.floatvalue ? 1 : 0
                case P_LOGIC_LESS:
                    v1.intvalue = v1.intvalue < v2!.intvalue ? 1 : 0
                    v1.floatvalue = v1.floatvalue < v2!.floatvalue ? 1 : 0
                case P_RSHIFT:
                    v1.intvalue >>= v2!.intvalue
                case P_LSHIFT:
                    v1.intvalue <<= v2!.intvalue
                case P_BIN_AND:
                    v1.intvalue &= v2!.intvalue
                case P_BIN_OR:
                    v1.intvalue |= v2!.intvalue
                case P_BIN_XOR:
                    v1.intvalue ^= v2!.intvalue
                case P_COLON:
                    if !gotquestmarkvalue {
                        SourceError(source, ": without ? in #if/#elif")
                        error = 1
                        break
                    } //end if
                    if integer != 0 {
                        if questmarkintvalue == 0 { v1.intvalue = v2!.intvalue }
                    } //end if
                    else {
                        if questmarkfloatvalue == 0 { v1.floatvalue = v2!.floatvalue }
                    } //end else
                    gotquestmarkvalue = false
                case P_QUESTIONMARK:
                    if gotquestmarkvalue {
                        SourceError(source, "? after ? in #if/#elif")
                        error = 1
                        break
                    } //end if
                    questmarkintvalue = v1.intvalue
                    questmarkfloatvalue = v1.floatvalue
                    gotquestmarkvalue = true
                default:
                    break
                } //end switch
                if error != 0 { break }
                //if not an operator with arity 1
                if o!.mOperator != P_LOGIC_NOT && o!.mOperator != P_BIN_NOT {
                    //remove the second value if not question mark operator
                    if o!.mOperator != P_QUESTIONMARK { v = v!.next }
                    //
                    if v!.prev != nil { v!.prev!.next = v!.next } else { firstvalue = v!.next }
                    if v!.next != nil { v!.next!.prev = v!.prev } else { lastvalue = v!.prev }
                    //FreeMemory(v);
                } //end if
                //remove the operator
                if o!.prev != nil { o!.prev!.next = o!.next } else { firstoperator = o!.next }
                if o!.next != nil { o!.next!.prev = o!.prev } else { lastoperator = o!.prev }
                //FreeMemory(o);
            } //end while
            if firstvalue != nil {
                if intvalue != nil { intvalue!.pointee = firstvalue!.intvalue }
                if floatvalue != nil { floatvalue!.pointee = firstvalue!.floatvalue }
            } //end if
            // Raven's FreeOperator and FreeValue expand to nothing, so his two free walks have no line.
            if error == 0 { return 1 }
            if intvalue != nil { intvalue!.pointee = 0 }
            if floatvalue != nil { floatvalue!.pointee = 0 }
            return 0
        }
    }
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:2184
public func PC_Evaluate(_ source: Source, _ intvalue: UnsafeMutablePointer<Int32>?, _ floatvalue: UnsafeMutablePointer<Double>?, _ integer: Int32) -> Int32 {
    var defined: Bool = false

    if intvalue != nil { intvalue!.pointee = 0 }
    if floatvalue != nil { floatvalue!.pointee = 0 }
    //
    return Token.scratch { token -> Int32 in
        var firsttoken: Token?, lasttoken: Token?
        var t: Token?, nexttoken: Token?
        var define: Define?

        if PC_ReadLine(source, token) == 0 {
            SourceError(source, "no value after #if/#elif")
            return 0
        } //end if
        firsttoken = nil
        lasttoken = nil
        repeat {
            //if the token is a name
            if token.type == TT_NAME {
                if defined {
                    defined = false
                    t = PC_CopyToken(token)
                    t!.next = nil
                    if lasttoken != nil { lasttoken!.next = t } else { firsttoken = t }
                    lasttoken = t
                } //end if
                else if strcmp(token.string, "defined") == 0 {
                    defined = true
                    t = PC_CopyToken(token)
                    t!.next = nil
                    if lasttoken != nil { lasttoken!.next = t } else { firsttoken = t }
                    lasttoken = t
                } //end if
                else {
                    //then it must be a define
                    define = PC_FindHashedDefine(source.definehash!, token.string)
                    if define == nil {
                        SourceError(source, "can't evaluate %s, not defined", token.string)
                        return 0
                    } //end if
                    if PC_ExpandDefineIntoSource(source, token, define!) == 0 { return 0 }
                } //end else
            } //end if
            //if the token is a number or a punctuation
            else if token.type == TT_NUMBER || token.type == TT_PUNCTUATION {
                t = PC_CopyToken(token)
                t!.next = nil
                if lasttoken != nil { lasttoken!.next = t } else { firsttoken = t }
                lasttoken = t
            } //end else
            else { //can't evaluate the token
                SourceError(source, "can't evaluate %s", token.string)
                return 0
            } //end else
        } while PC_ReadLine(source, token) != 0
        //
        if PC_EvaluateTokens(source, firsttoken!, intvalue, floatvalue, integer) == 0 { return 0 }
        //
        t = firsttoken
        while t != nil {
            nexttoken = t!.next
            PC_FreeToken(t!)
            t = nexttoken
        } //end for
        //
        return 1
    }
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:2283
public func PC_DollarEvaluate(_ source: Source, _ intvalue: UnsafeMutablePointer<Int32>?, _ floatvalue: UnsafeMutablePointer<Double>?, _ integer: Int32) -> Int32 {
    var defined: Bool = false

    if intvalue != nil { intvalue!.pointee = 0 }
    if floatvalue != nil { floatvalue!.pointee = 0 }
    //
    return Token.scratch { token -> Int32 in
        var indent: Int32
        var firsttoken: Token?, lasttoken: Token?
        var t: Token?, nexttoken: Token?
        var define: Define?

        if PC_ReadSourceToken(source, token) == 0 {
            SourceError(source, "no leading ( after $evalint/$evalfloat")
            return 0
        } //end if
        if PC_ReadSourceToken(source, token) == 0 {
            SourceError(source, "nothing to evaluate")
            return 0
        } //end if
        indent = 1
        firsttoken = nil
        lasttoken = nil
        repeat {
            //if the token is a name
            if token.type == TT_NAME {
                if defined {
                    defined = false
                    t = PC_CopyToken(token)
                    t!.next = nil
                    if lasttoken != nil { lasttoken!.next = t } else { firsttoken = t }
                    lasttoken = t
                } //end if
                else if strcmp(token.string, "defined") == 0 {
                    defined = true
                    t = PC_CopyToken(token)
                    t!.next = nil
                    if lasttoken != nil { lasttoken!.next = t } else { firsttoken = t }
                    lasttoken = t
                } //end if
                else {
                    //then it must be a define
                    define = PC_FindHashedDefine(source.definehash!, token.string)
                    if define == nil {
                        SourceError(source, "can't evaluate %s, not defined", token.string)
                        return 0
                    } //end if
                    if PC_ExpandDefineIntoSource(source, token, define!) == 0 { return 0 }
                } //end else
            } //end if
            //if the token is a number or a punctuation
            else if token.type == TT_NUMBER || token.type == TT_PUNCTUATION {
                if token.stringBuffer[0] == Int32(ascii: "(") {
                    indent += 1
                } else if token.stringBuffer[0] == Int32(ascii: ")") {
                    indent -= 1
                }
                if indent <= 0 { break }
                t = PC_CopyToken(token)
                t!.next = nil
                if lasttoken != nil { lasttoken!.next = t } else { firsttoken = t }
                lasttoken = t
            } //end else
            else { //can't evaluate the token
                SourceError(source, "can't evaluate %s", token.string)
                return 0
            } //end else
        } while PC_ReadSourceToken(source, token) != 0
        //
        if PC_EvaluateTokens(source, firsttoken!, intvalue, floatvalue, integer) == 0 { return 0 }
        //
        t = firsttoken
        while t != nil {
            nexttoken = t!.next
            PC_FreeToken(t!)
            t = nexttoken
        } //end for
        //
        return 1
    }
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:2391
public func PC_Directive_elif(_ source: Source) -> Int32 {
    var value: Int32 = 0
    var type: Int32 = 0, skip: Int32 = 0

    PC_PopIndent(source, &type, &skip)
    if type == 0 || type == INDENT_ELSE {
        SourceError(source, "misplaced #elif")
        return 0
    } //end if
    if PC_Evaluate(source, &value, nil, 1) == 0 { return 0 }
    skip = (value == 0) ? 1 : 0
    PC_PushIndent(source, INDENT_ELIF, skip)
    return 1
} //end of the function PC_Directive_elif

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:2413
public func PC_Directive_if(_ source: Source) -> Int32 {
    var value: Int32 = 0
    var skip: Int32

    if PC_Evaluate(source, &value, nil, 1) == 0 { return 0 }
    skip = (value == 0) ? 1 : 0
    PC_PushIndent(source, INDENT_IF, skip)
    return 1
} //end of the function PC_Directive

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:2429
public func PC_Directive_line(_ source: Source) -> Int32 {
    SourceError(source, "#line directive not supported")
    return 0
} //end of the function PC_Directive_line

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:2440
public func PC_Directive_error(_ source: Source) -> Int32 {
    return Token.scratch { token -> Int32 in
        strcpy(&token.stringBuffer, "")
        _ = PC_ReadSourceToken(source, token)
        SourceError(source, "#error directive: %s", token.string)
        return 0
    }
} //end of the function PC_Directive_error

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:2455
public func PC_Directive_pragma(_ source: Source) -> Int32 {
    return Token.scratch { token -> Int32 in
        SourceWarning(source, "#pragma directive not supported")
        while PC_ReadLine(source, token) != 0 {}
        return 1
    }
} //end of the function PC_Directive_pragma

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:2469
public func UnreadSignToken(_ source: Source) {
    Token.scratch { token in
        token.line = source.scriptstack!.line
        token.whitespace_p = source.scriptstack!.script_p
        token.endwhitespace_p = source.scriptstack!.script_p
        token.linescrossed = 0
        strcpy(&token.stringBuffer, "-")
        token.type = TT_PUNCTUATION
        token.subtype = P_SUB
        PC_UnreadSourceToken(source, token)
    }
} //end of the function UnreadSignToken

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:2488
public func PC_Directive_eval(_ source: Source) -> Int32 {
    var value: Int32 = 0

    return Token.scratch { token -> Int32 in
        if PC_Evaluate(source, &value, nil, 1) == 0 { return 0 }
        //
        token.line = source.scriptstack!.line
        token.whitespace_p = source.scriptstack!.script_p
        token.endwhitespace_p = source.scriptstack!.script_p
        token.linescrossed = 0
        strcpy(&token.stringBuffer, JKAShared.format("%d", [abs(value)]))
        token.type = TT_NUMBER
        token.subtype = TT_INTEGER | TT_LONG | TT_DECIMAL
        PC_UnreadSourceToken(source, token)
        if value < 0 { UnreadSignToken(source) }
        return 1
    }
} //end of the function PC_Directive_eval

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:2512
public func PC_Directive_evalfloat(_ source: Source) -> Int32 {
    var value: Double = 0

    return Token.scratch { token -> Int32 in
        if PC_Evaluate(source, nil, &value, 0) == 0 { return 0 }
        token.line = source.scriptstack!.line
        token.whitespace_p = source.scriptstack!.script_p
        token.endwhitespace_p = source.scriptstack!.script_p
        token.linescrossed = 0
        strcpy(&token.stringBuffer, JKAShared.format("%1.2f", [abs(value)]))
        token.type = TT_NUMBER
        token.subtype = TT_FLOAT | TT_LONG | TT_DECIMAL
        PC_UnreadSourceToken(source, token)
        if value < 0 { UnreadSignToken(source) }
        return 1
    }
} //end of the function PC_Directive_evalfloat

/// Source: oracle/codemp/botlib/l_precomp.cpp:2554
public func PC_ReadDirective(_ source: Source) -> Int32 {
    return Token.scratch { token -> Int32 in
        var i: Int32

        //read the directive name
        if PC_ReadSourceToken(source, token) == 0 {
            SourceError(source, "found # without name")
            return 0
        } //end if
        //directive name must be on the same line
        if token.linescrossed > 0 {
            PC_UnreadSourceToken(source, token)
            SourceError(source, "found # at end of line")
            return 0
        } //end if
        //if if is a name
        if token.type == TT_NAME {
            //find the precompiler directive
            i = 0
            while directives[i].name != nil {
                if strcmp(directives[i].name!, token.string) == 0 {
                    return directives[i].func!(source)
                } //end if
                i += 1
            } //end for
        } //end if
        SourceError(source, "unknown precompiler directive %s", token.string)
        return 0
    }
} //end of the function PC_ReadDirective

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:2593
public func PC_DollarDirective_evalint(_ source: Source) -> Int32 {
    var value: Int32 = 0

    return Token.scratch { token -> Int32 in
        if PC_DollarEvaluate(source, &value, nil, 1) == 0 { return 0 }
        //
        token.line = source.scriptstack!.line
        token.whitespace_p = source.scriptstack!.script_p
        token.endwhitespace_p = source.scriptstack!.script_p
        token.linescrossed = 0
        strcpy(&token.stringBuffer, JKAShared.format("%d", [abs(value)]))
        token.type = TT_NUMBER
        token.subtype = TT_INTEGER | TT_LONG | TT_DECIMAL
        // C converts the `signed long` value to the `unsigned long` and the `double` at each store.
        token.intvalue = UInt32(bitPattern: value)
        token.floatvalue = Double(value)
        PC_UnreadSourceToken(source, token)
        if value < 0 { UnreadSignToken(source) }
        return 1
    }
} //end of the function PC_DollarDirective_evalint

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:2621
public func PC_DollarDirective_evalfloat(_ source: Source) -> Int32 {
    var value: Double = 0

    return Token.scratch { token -> Int32 in
        if PC_DollarEvaluate(source, nil, &value, 0) == 0 { return 0 }
        token.line = source.scriptstack!.line
        token.whitespace_p = source.scriptstack!.script_p
        token.endwhitespace_p = source.scriptstack!.script_p
        token.linescrossed = 0
        strcpy(&token.stringBuffer, JKAShared.format("%1.2f", [abs(value)]))
        token.type = TT_NUMBER
        token.subtype = TT_FLOAT | TT_LONG | TT_DECIMAL
        // Port-note: Raven's `(unsigned long) value` of a negative value is undefined in C, rule 19.
        // The port takes the value through a 64-bit integer and keeps the low 32 bits, the result of the MSVC build.
        token.intvalue = UInt32(truncatingIfNeeded: Int64(value))
        token.floatvalue = value
        PC_UnreadSourceToken(source, token)
        if value < 0 { UnreadSignToken(source) }
        return 1
    }
} //end of the function PC_DollarDirective_evalfloat

/// Source: oracle/codemp/botlib/l_precomp.cpp:2655
public func PC_ReadDollarDirective(_ source: Source) -> Int32 {
    return Token.scratch { token -> Int32 in
        var i: Int32

        //read the directive name
        if PC_ReadSourceToken(source, token) == 0 {
            SourceError(source, "found $ without name")
            return 0
        } //end if
        //directive name must be on the same line
        if token.linescrossed > 0 {
            PC_UnreadSourceToken(source, token)
            SourceError(source, "found $ at end of line")
            return 0
        } //end if
        //if if is a name
        if token.type == TT_NAME {
            //find the precompiler directive
            i = 0
            while dollardirectives[i].name != nil {
                if strcmp(dollardirectives[i].name!, token.string) == 0 {
                    return dollardirectives[i].func!(source)
                } //end if
                i += 1
            } //end for
        } //end if
        PC_UnreadSourceToken(source, token)
        SourceError(source, "unknown precompiler directive %s", token.string)
        return 0
    }
} //end of the function PC_ReadDirective

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:2749
public func PC_ReadToken(_ source: Source, _ token: Token) -> Int32 {
    var define: Define?

    while true {
        if PC_ReadSourceToken(source, token) == 0 { return 0 }
        //check for precompiler directives
        if token.type == TT_PUNCTUATION && token.stringBuffer[0] == Int32(ascii: "@") {	// It is a StringEd key
            var holdString: Int32, holdString2 = CharBuf(MAX_TOKEN)

            _ = PC_ReadSourceToken(source, token)
            holdString = 1
            holdString2 = token.stringBuffer
            // Port-note: Raven copies sizeof(token->string) bytes to &token->string[1], so the last byte lands in the next field, rule 19.
            // The copy stops at the end of `string`.
            strncpy(&token.stringBuffer, String(holdString2), MAX_TOKEN - holdString, at: holdString)
            token.stringBuffer[0] = Int32(ascii: "@")
            return 1
        }

        if token.type == TT_PUNCTUATION && token.stringBuffer[0] == Int32(ascii: "#") {
            //read the precompiler directive
            if PC_ReadDirective(source) == 0 { return 0 }
            continue
        } //end if
        if token.type == TT_PUNCTUATION && token.stringBuffer[0] == Int32(ascii: "$") {
            //read the precompiler directive
            if PC_ReadDollarDirective(source) == 0 { return 0 }
            continue
        } //end if
        // recursively concatenate strings that are behind each other still resolving defines
        if token.type == TT_STRING {
            let earlyOut = Token.scratch { newtoken -> Bool in
                if PC_ReadToken(source, newtoken) != 0 {
                    if newtoken.type == TT_STRING {
                        token.stringBuffer[strlen(token.string) - 1] = 0
                        if strlen(token.string) + strlen(newtoken.stringBuffer[1...]) + 1 >= MAX_TOKEN {
                            SourceError(source, "string longer than MAX_TOKEN %d\n", MAX_TOKEN)
                            return true
                        }
                        strcat(&token.stringBuffer, newtoken.stringBuffer[1...])
                    } else {
                        PC_UnreadToken(source, newtoken)
                    }
                }
                return false
            }
            if earlyOut { return 0 }
        } //end if
        //if skipping source because of conditional compilation
        if source.skip != 0 { continue }
        //if the token is a name
        if token.type == TT_NAME {
            //check if the name is a define macro
            define = PC_FindHashedDefine(source.definehash!, token.string)
            //if it is a define macro
            if define != nil {
                //expand the defined macro
                if PC_ExpandDefineIntoSource(source, token, define!) == 0 { return 0 }
                continue
            } //end if
        } //end if
        //copy token for unreading
        source.token.copy(from: token)
        //found a token
        return 1
    } //end while
} //end of the function PC_ReadToken

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:2844
public func PC_ExpectTokenString(_ source: Source, _ string: String) -> Int32 {
    return Token.scratch { token -> Int32 in
        if PC_ReadToken(source, token) == 0 {
            SourceError(source, "couldn't find expected %s", string)
            return 0
        } //end if

        if strcmp(token.string, string) != 0 {
            SourceError(source, "expected %s, found %s", string, token.string)
            return 0
        } //end if
        return 1
    }
} //end of the function PC_ExpectTokenString

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:2867
public func PC_ExpectTokenType(_ source: Source, _ type: Int32, _ subtype: Int32, _ token: Token) -> Int32 {
    var str = CharBuf(MAX_TOKEN)

    if PC_ReadToken(source, token) == 0 {
        SourceError(source, "couldn't read expected token")
        return 0
    } //end if

    if token.type != type {
        strcpy(&str, "")
        if type == TT_STRING { strcpy(&str, "string") }
        if type == TT_LITERAL { strcpy(&str, "literal") }
        if type == TT_NUMBER { strcpy(&str, "number") }
        if type == TT_NAME { strcpy(&str, "name") }
        if type == TT_PUNCTUATION { strcpy(&str, "punctuation") }
        SourceError(source, "expected a %s, found %s", str, token.string)
        return 0
    } //end if
    if token.type == TT_NUMBER {
        if (token.subtype & subtype) != subtype {
            if (subtype & TT_DECIMAL) != 0 { strcpy(&str, "decimal") }
            if (subtype & TT_HEX) != 0 { strcpy(&str, "hex") }
            if (subtype & TT_OCTAL) != 0 { strcpy(&str, "octal") }
            if (subtype & TT_BINARY) != 0 { strcpy(&str, "binary") }
            if (subtype & TT_LONG) != 0 { strcat(&str, " long") }
            if (subtype & TT_UNSIGNED) != 0 { strcat(&str, " unsigned") }
            if (subtype & TT_FLOAT) != 0 { strcat(&str, " float") }
            if (subtype & TT_INTEGER) != 0 { strcat(&str, " integer") }
            SourceError(source, "expected %s, found %s", str, token.string)
            return 0
        } //end if
    } //end if
    else if token.type == TT_PUNCTUATION {
        if token.subtype != subtype {
            SourceError(source, "found %s", token.string)
            return 0
        } //end if
    } //end else if
    return 1
} //end of the function PC_ExpectTokenType

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:2920
public func PC_ExpectAnyToken(_ source: Source, _ token: Token) -> Int32 {
    if PC_ReadToken(source, token) == 0 {
        SourceError(source, "couldn't read expected token")
        return 0
    } //end if
    else {
        return 1
    } //end else
} //end of the function PC_ExpectAnyToken

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:2938
public func PC_CheckTokenString(_ source: Source, _ string: String) -> Int32 {
    return Token.scratch { tok -> Int32 in
        if PC_ReadToken(source, tok) == 0 { return 0 }
        //if the token is available
        if strcmp(tok.string, string) == 0 { return 1 }
        //
        PC_UnreadSourceToken(source, tok)
        return 0
    }
} //end of the function PC_CheckTokenString

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:2955
public func PC_CheckTokenType(_ source: Source, _ type: Int32, _ subtype: Int32, _ token: Token) -> Int32 {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    return Token.scratch { tok -> Int32 in
        if PC_ReadToken(source, tok) == 0 { return 0 }
        //if the type matches
        if tok.type == type &&
            (tok.subtype & subtype) == subtype {
            token.copy(from: tok)
            return 1
        } //end if
        //
        PC_UnreadSourceToken(source, tok)
        return 0
    }
} //end of the function PC_CheckTokenType

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:2977
public func PC_SkipUntilString(_ source: Source, _ string: String) -> Int32 {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    return Token.scratch { token -> Int32 in
        while PC_ReadToken(source, token) != 0 {
            if strcmp(token.string, string) == 0 { return 1 }
        } //end while
        return 0
    }
} //end of the function PC_SkipUntilString

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:2993
public func PC_UnreadLastToken(_ source: Source) {
    PC_UnreadSourceToken(source, source.token)
} //end of the function PC_UnreadLastToken

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:3003
public func PC_UnreadToken(_ source: Source, _ token: Token) {
    PC_UnreadSourceToken(source, token)
} //end of the function PC_UnreadToken

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:3013
public func PC_SetIncludePath(_ source: Source, _ path: String) {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    strncpy(&source.includepathBuffer, path, MAX_PATH)
    //add trailing path seperator
    // AI: Raven reads `filename[1023]`, the byte before `includepath`, for an empty path, and that byte is always 0.
    // The empty test gives the same append of the separator.
    if strlen(source.includepathBuffer) == 0 ||
        (source.includepathBuffer[strlen(source.includepathBuffer) - 1] != Int32(ascii: "\\") &&
        source.includepathBuffer[strlen(source.includepathBuffer) - 1] != Int32(ascii: "/")) {
        strcat(&source.includepathBuffer, PATHSEPERATOR_STR)
    } //end if
}

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:3029
public func PC_SetPunctuations(_ source: Source, _ p: Punctuation) {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    source.punctuations = p
} //end of the function PC_SetPunctuations

//============================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:3039
public func LoadSourceFile(_ filename: String) -> Source? {
    let source: Source
    let script: Script?

    PC_InitTokenHeap()

    if globaldefines == nil {
        // The table holds `DEFINEHASHSIZE` record pointers, and `UInt.byteCount` is the size of one pointer.
        globaldefines = Slots(pointers: GetClearedMemory(DEFINEHASHSIZE * Int32(UInt.byteCount)), count: Int(DEFINEHASHSIZE))
    }

    script = LoadScriptFile(filename)
    if script == nil { return nil }

    script!.next = nil

    source = Source(GetMemory(Int32(Source.byteCount))!)
    source.clear()

    strncpy(&source.filenameBuffer, filename, MAX_PATH)
    source.scriptstack = script
    source.tokens = nil
    source.defines = nil
    source.indentstack = nil
    source.skip = 0

    // The table holds `DEFINEHASHSIZE` record pointers, and `UInt.byteCount` is the size of one pointer.
    source.definehash = Slots(pointers: GetClearedMemory(DEFINEHASHSIZE * Int32(UInt.byteCount)), count: Int(DEFINEHASHSIZE))
    PC_AddGlobalDefinesToSource(source)
    return source
} //end of the function LoadSourceFile

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:3080
public func LoadSourceMemory(_ ptr: String, _ length: Int32, _ name: String) -> Source? {
    // Port-note: Raven calls this function from no file of either tree, so it is dead.
    let source: Source
    let script: Script?

    PC_InitTokenHeap()

    script = LoadScriptMemory(ptr, length, name)
    if script == nil { return nil }
    script!.next = nil

    source = Source(GetMemory(Int32(Source.byteCount))!)
    source.clear()

    strncpy(&source.filenameBuffer, name, MAX_PATH)
    source.scriptstack = script
    source.tokens = nil
    source.defines = nil
    source.indentstack = nil
    source.skip = 0

    // The table holds `DEFINEHASHSIZE` record pointers, and `UInt.byteCount` is the size of one pointer.
    source.definehash = Slots(pointers: GetClearedMemory(DEFINEHASHSIZE * Int32(UInt.byteCount)), count: Int(DEFINEHASHSIZE))
    PC_AddGlobalDefinesToSource(source)
    return source
} //end of the function LoadSourceMemory

//============================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:3113
public func FreeSource(_ source: Source) {
    var script: Script?
    var token: Token?
    var define: Define?
    var indent: Indent?
    var nextdefine: Define?
    var i: Int32

    //PC_PrintDefineHashTable(source->definehash);
    //free all the scripts
    while source.scriptstack != nil {
        script = source.scriptstack
        source.scriptstack = source.scriptstack!.next
        FreeScript(script!)
    } //end for
    //free all the tokens
    while source.tokens != nil {
        token = source.tokens
        source.tokens = source.tokens!.next
        PC_FreeToken(token!)
    } //end for
    i = 0
    while i < DEFINEHASHSIZE {
        define = source.definehash![i]
        while define != nil {
            nextdefine = define!.hashnext

            if (define!.flags & DEFINE_GLOBAL) == 0 {
                PC_FreeDefine(define!)
            }

            define = nextdefine
        } //end while

        source.definehash![i] = nil
        i += 1
    } //end for
    //free all indents
    while source.indentstack != nil {
        indent = source.indentstack
        source.indentstack = source.indentstack!.next
        FreeMemory(indent!.handle)
    } //end for
    //
    if source.definehash != nil { FreeMemory(OpaquePointer(source.definehash!.base)) }
    //free the source itself
    FreeMemory(source.handle)
} //end of the function FreeSource

/// Source: oracle/codemp/botlib/l_precomp.cpp:3189
public func PC_LoadSourceHandle(_ filename: String) -> Int32 {
    let source: Source?
    var i: Int32

    i = 1
    while i < MAX_SOURCEFILES {
        if sourceFiles[i] == nil {
            break
        }
        i += 1
    } //end for
    if i >= MAX_SOURCEFILES {
        return 0
    }
    PS_SetBaseFolder("")
    source = LoadSourceFile(filename)
    if source == nil {
        return 0
    }
    sourceFiles[i] = source
    return i
} //end of the function PC_LoadSourceHandle

//============================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:3214
public func PC_FreeSourceHandle(_ handle: Int32) -> Int32 {
    if handle < 1 || handle >= MAX_SOURCEFILES {
        return 0
    }
    if sourceFiles[handle] == nil {
        return 0
    }

    FreeSource(sourceFiles[handle]!)
    sourceFiles[handle] = nil
    return 1
} //end of the function PC_FreeSourceHandle

/// Source: oracle/codemp/botlib/l_precomp.cpp:3226
public func PC_LoadGlobalDefines(_ filename: String) -> Int32 {
    return Token.scratch { token -> Int32 in
        var handle: Int32

        handle = PC_LoadSourceHandle(filename)
        if handle < 1 {
            return 0
        }

        addGlobalDefine = true

        // Read all the token files which will add the defines globally
        while PC_ReadToken(sourceFiles[handle]!, token) != 0 {}

        addGlobalDefine = false

        _ = PC_FreeSourceHandle(handle)

        return 1
    }
}

//============================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:3253
public func PC_ReadTokenHandle(_ handle: Int32, _ pc_token: JKAMP.PcToken) -> Int32 {
    return Token.scratch { token -> Int32 in
        var ret: Int32

        if handle < 1 || handle >= MAX_SOURCEFILES {
            return 0
        }
        if sourceFiles[handle] == nil {
            return 0
        }

        ret = PC_ReadToken(sourceFiles[handle]!, token)
        strcpy(&pc_token.stringBuffer, token.string)
        pc_token.type = token.type
        pc_token.subtype = token.subtype
        // C converts the `unsigned long` to the `int` and the `double` to the `float` at each store.
        pc_token.intvalue = Int32(bitPattern: token.intvalue)
        pc_token.floatvalue = Float(token.floatvalue)
        if (pc_token.type == TT_STRING) && (pc_token.stringBuffer[0] != Int32(ascii: "@")) {
            StripDoubleQuotes(&pc_token.stringBuffer)
        }

        return ret
    }
} //end of the function PC_ReadTokenHandle

//============================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:3280
public func PC_SourceFileAndLine(_ handle: Int32, _ filename: inout JKAShared.CharBuf, _ line: inout Int32) -> Int32 {
    if handle < 1 || handle >= MAX_SOURCEFILES {
        return 0
    }
    if sourceFiles[handle] == nil {
        return 0
    }

    strcpy(&filename, sourceFiles[handle]!.filename)
    if sourceFiles[handle]!.scriptstack != nil {
        line = sourceFiles[handle]!.scriptstack!.line
    } else {
        line = 0
    }
    return 1
} //end of the function PC_SourceFileAndLine

//============================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:3300
public func PC_SetBaseFolder(_ path: String) {
    PS_SetBaseFolder(path)
} //end of the function PC_SetBaseFolder

//============================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//============================================================================
/// Source: oracle/codemp/botlib/l_precomp.cpp:3310
public func PC_CheckOpenSourceHandles() {
    var i: Int32

    i = 1
    while i < MAX_SOURCEFILES {
        if sourceFiles[i] != nil {
            botimport.runPrint(PRT_ERROR, "file %s still open in precompiler\n", sourceFiles[i]!.scriptstack!.filename)
        } //end if
        i += 1
    } //end for
} //end of the function PC_CheckOpenSourceHandles
