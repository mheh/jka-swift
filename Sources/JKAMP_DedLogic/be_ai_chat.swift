import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/botlib/be_ai_chat.cpp:33
let ESCAPE_CHAR = 0x01 as Int32

/// Source: oracle/codemp/botlib/be_ai_chat.cpp:41
let MT_VARIABLE = 1 as Int32

/// Source: oracle/codemp/botlib/be_ai_chat.cpp:42
let MT_STRING = 2 as Int32

/// Source: oracle/codemp/botlib/be_ai_chat.cpp:44
let RCKFL_AND = 1 as Int32

/// Source: oracle/codemp/botlib/be_ai_chat.cpp:45
let RCKFL_NOT = 2 as Int32

/// Source: oracle/codemp/botlib/be_ai_chat.cpp:46
let RCKFL_NAME = 4 as Int32

/// Source: oracle/codemp/botlib/be_ai_chat.cpp:47
let RCKFL_STRING = 8 as Int32

/// Source: oracle/codemp/botlib/be_ai_chat.cpp:48
let RCKFL_VARIABLES = 16 as Int32

/// Source: oracle/codemp/botlib/be_ai_chat.cpp:49
let RCKFL_BOTNAMES = 32 as Int32

/// Source: oracle/codemp/botlib/be_ai_chat.cpp:50
let RCKFL_GENDERFEMALE = 64 as Int32

/// Source: oracle/codemp/botlib/be_ai_chat.cpp:51
let RCKFL_GENDERMALE = 128 as Int32

/// Source: oracle/codemp/botlib/be_ai_chat.cpp:52
let RCKFL_GENDERLESS = 256 as Int32

/// Source: oracle/codemp/botlib/be_ai_chat.cpp:54
let CHATMESSAGE_RECENTTIME = 20 as Int32

/// Source: oracle/codemp/botlib/be_ai_chat.cpp:181
var ichatdata: Slots<BotIchatdata?> { world.storage.ichatdata }

/// Source: oracle/codemp/botlib/be_ai_chat.cpp:183
var botchatstates: Slots<BotChatstate?> { world.storage.botchatstates }

/// Source: oracle/codemp/botlib/be_ai_chat.cpp:185
var consolemessageheap: Slots<BotConsolemessage>? {
    get { world.variables.consolemessageheap }
    set { world.variables.consolemessageheap = newValue }
}

/// Source: oracle/codemp/botlib/be_ai_chat.cpp:186
var freeconsolemessages: BotConsolemessage? {
    get { world.variables.freeconsolemessages }
    set { world.variables.freeconsolemessages = newValue }
}

/// Source: oracle/codemp/botlib/be_ai_chat.cpp:188
var matchtemplates: BotMatchtemplate? {
    get { world.variables.matchtemplates }
    set { world.variables.matchtemplates = newValue }
}

/// Source: oracle/codemp/botlib/be_ai_chat.cpp:190
var synonyms: BotSynonymlist? {
    get { world.variables.synonyms }
    set { world.variables.synonyms = newValue }
}

/// Source: oracle/codemp/botlib/be_ai_chat.cpp:192
var randomstrings: BotRandomlist? {
    get { world.variables.randomstrings }
    set { world.variables.randomstrings = newValue }
}

/// Source: oracle/codemp/botlib/be_ai_chat.cpp:194
var replychats: BotReplychat? {
    get { world.variables.replychats }
    set { world.variables.replychats = newValue }
}

//========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:202
func BotChatStateFromHandle(_ handle: Int32) -> BotChatstate? {
    if handle <= 0 || handle > MAX_CLIENTS {
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_FATAL, "chat state handle %d out of range\n", handle);
        portMissing("BotChatStateFromHandle", source: "oracle/codemp/botlib/be_ai_chat.cpp:202")
        return nil
    }
    if botchatstates[handle] == nil {
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_FATAL, "invalid chat state %d\n", handle);
        portMissing("BotChatStateFromHandle", source: "oracle/codemp/botlib/be_ai_chat.cpp:202")
        return nil
    }
    return botchatstates[handle]
}

//===========================================================================
// initialize the heap with unused console messages
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:223
func InitConsoleMessageHeap() {
    var i: Int32
    var max_messages: Int32

    if consolemessageheap != nil { FreeMemory(consolemessageheap![0].handle) }
    //
    max_messages = Int32(LibVarValue("max_messages", "1024"))
    consolemessageheap = Slots<BotConsolemessage>(GetClearedHunkMemory(UInt32(max_messages * Int32(BotConsolemessage.byteCount))), count: max_messages)
    consolemessageheap![0].prev = nil
    consolemessageheap![0].next = consolemessageheap![1]
    i = 1
    while i < max_messages - 1 {
        consolemessageheap![i].prev = consolemessageheap![i - 1]
        consolemessageheap![i].next = consolemessageheap![i + 1]
        i += 1
    }
    consolemessageheap![max_messages - 1].prev = consolemessageheap![max_messages - 2]
    consolemessageheap![max_messages - 1].next = nil
    //pointer to the free console messages
    freeconsolemessages = consolemessageheap![0]
}

//===========================================================================
// allocate one console message from the heap
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:251
func AllocConsoleMessage() -> BotConsolemessage? {
    var message: BotConsolemessage?
    message = freeconsolemessages
    if freeconsolemessages != nil { freeconsolemessages = freeconsolemessages!.next }
    if freeconsolemessages != nil { freeconsolemessages!.prev = nil }
    return message
}

//===========================================================================
// deallocate one console message from the heap
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:266
func FreeConsoleMessage(_ message: BotConsolemessage) {
    if freeconsolemessages != nil { freeconsolemessages!.prev = message }
    message.prev = nil
    message.next = freeconsolemessages
    freeconsolemessages = message
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:279
func BotRemoveConsoleMessage(_ chatstate: Int32, _ handle: Int32) {
    var m: BotConsolemessage?
    var nextm: BotConsolemessage?

    guard let cs = BotChatStateFromHandle(chatstate) else { return }

    m = cs.firstmessage
    while m != nil {
        nextm = m!.next
        // Port-note: The `handle` field of `bot_consolemessage_t` has no accessor in its view, row P2 of the bot-ai round.
        // Raven wrote: if (m->handle == handle) { if (m->next) m->next->prev = m->prev; else cs->lastmessage = m->prev; if (m->prev) m->prev->next = m->next; else cs->firstmessage = m->next; FreeConsoleMessage(m); cs->numconsolemessages--; break; }
        portMissing("BotRemoveConsoleMessage", source: "oracle/codemp/botlib/be_ai_chat.cpp:279")
        m = nextm
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:309
func BotQueueConsoleMessage(_ chatstate: Int32, _ type: Int32, _ message: String) {
    guard let cs = BotChatStateFromHandle(chatstate) else { return }

    guard let m = AllocConsoleMessage() else {
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_ERROR, "empty console message heap\n");
        portMissing("BotQueueConsoleMessage", source: "oracle/codemp/botlib/be_ai_chat.cpp:309")
        return
    }
    // Port-note: The `handle` fields of `bot_chatstate_t` and `bot_consolemessage_t` have no accessor in their views, row P2 of the bot-ai round.
    // Raven wrote: cs->handle++; if (cs->handle <= 0 || cs->handle > 8192) cs->handle = 1; m->handle = cs->handle;
    portMissing("BotQueueConsoleMessage", source: "oracle/codemp/botlib/be_ai_chat.cpp:309")
    m.time = AAS_Time()
    m.type = type
    strncpy(&m.messageBuffer, message, MAX_MESSAGE_SIZE)
    m.next = nil
    if cs.lastmessage != nil {
        cs.lastmessage!.next = m
        m.prev = cs.lastmessage
        cs.lastmessage = m
    } else {
        cs.lastmessage = m
        cs.firstmessage = m
        m.prev = nil
    }
    cs.numconsolemessages += 1
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:350
func BotNextConsoleMessage(_ chatstate: Int32, _ cm: BotConsolemessage) -> Int32 {
    guard let cs = BotChatStateFromHandle(chatstate) else { return 0 }
    if cs.firstmessage != nil {
        cm.copy(from: cs.firstmessage!)
        cm.prev = nil
        cm.next = cm.prev
        // Port-note: The `handle` field of `bot_consolemessage_t` has no accessor in its view, row P2 of the bot-ai round.
        // Raven wrote: return cm->handle;
        portMissing("BotNextConsoleMessage", source: "oracle/codemp/botlib/be_ai_chat.cpp:350")
    }
    return 0
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:370
func BotNumConsoleMessages(_ chatstate: Int32) -> Int32 {
    guard let cs = BotChatStateFromHandle(chatstate) else { return 0 }
    return cs.numconsolemessages
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:384
func IsWhiteSpace(_ c: CChar) -> Int32 {
    if (c >= Int32(ascii: "a") && c <= Int32(ascii: "z"))
        || (c >= Int32(ascii: "A") && c <= Int32(ascii: "Z"))
        || (c >= Int32(ascii: "0") && c <= Int32(ascii: "9"))
        || c == Int32(ascii: "(") || c == Int32(ascii: ")")
        || c == Int32(ascii: "?") || c == Int32(ascii: ":")
        || c == Int32(ascii: "'") || c == Int32(ascii: "/")
        || c == Int32(ascii: ",") || c == Int32(ascii: ".")
        || c == Int32(ascii: "[") || c == Int32(ascii: "]")
        || c == Int32(ascii: "-") || c == Int32(ascii: "_")
        || c == Int32(ascii: "+") || c == Int32(ascii: "=") {
        return 0
    }
    return 1
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:404
func BotRemoveTildes(_ message: inout JKAShared.CharBuf) {
    var i: Int32

    //remove all tildes from the chat message
    i = 0
    while message[i] != 0 {
        if message[i] == Int32(ascii: "~") {
            memmove(&message, i + 1, strlen(message[(i + 1)...]) + 1, at: i)
        }
        i += 1
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:423
func UnifyWhiteSpaces(_ string: inout JKAShared.CharBuf) {
    var ptr: Int32
    var oldptr: Int32

    oldptr = 0
    ptr = oldptr
    while string[ptr] != 0 {
        while string[ptr] != 0 && IsWhiteSpace(string[ptr]) != 0 { ptr += 1 }
        if ptr > oldptr {
            //if not at the start and not at the end of the string
            //write only one space
            if oldptr > 0 && string[ptr] != 0 {
                string[oldptr] = Int32(ascii: " ")
                oldptr += 1
            }
            //remove all other white spaces
            if ptr > oldptr { memmove(&string, ptr, strlen(string[ptr...]) + 1, at: oldptr) }
        }
        while string[ptr] != 0 && IsWhiteSpace(string[ptr]) == 0 { ptr += 1 }
        oldptr = ptr
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:447
func StringContains(_ str1: inout JKAShared.CharBuf, _ str2: String, _ casesensitive: Int32) -> Int32 {
    var len: Int32
    var i: Int32
    var j: Int32
    var index: Int32
    // Raven steps his own `str1` pointer, so the body reads a byte offset into the buffer.
    var str1Index: Int32 = 0
    // Raven indexes his own `str2` parameter by byte, so the body reads a CharBuf of it.
    let str2 = CharBuf(str2)

    len = strlen(str1) - strlen(str2)
    index = 0
    i = 0
    while i <= len {
        j = 0
        while str2[j] != 0 {
            if casesensitive != 0 {
                if str1[str1Index + j] != str2[j] { break }
            } else {
                // Foundation also declares toupper, so the qualifier picks the C-locale form of JKAShared.
                if JKAShared.toupper(str1[str1Index + j]) != JKAShared.toupper(str2[j]) { break }
            }
            j += 1
        }
        if str2[j] == 0 { return index }
        i += 1
        str1Index += 1
        index += 1
    }
    return -1
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:478
func StringContainsWord(_ str1: inout JKAShared.CharBuf, _ str2: String, _ casesensitive: Int32) -> String? {
    var len: Int32
    var i: Int32
    var j: Int32
    // Raven steps his own `str1` pointer, so the body reads a byte offset into the buffer.
    var str1Index: Int32 = 0
    // Raven indexes his own `str2` parameter by byte, so the body reads a CharBuf of it.
    let str2 = CharBuf(str2)

    len = strlen(str1) - strlen(str2)
    i = 0
    while i <= len {
        //if not at the start of the string
        if i != 0 {
            //skip to the start of the next word
            while str1[str1Index] != 0 && str1[str1Index] != Int32(ascii: " ") && str1[str1Index] != Int32(ascii: ".") && str1[str1Index] != Int32(ascii: ",") && str1[str1Index] != Int32(ascii: "!") { str1Index += 1 }
            if str1[str1Index] == 0 { break }
            str1Index += 1
        }
        //compare the word
        j = 0
        while str2[j] != 0 {
            if casesensitive != 0 {
                if str1[str1Index + j] != str2[j] { break }
            } else {
                // Foundation also declares toupper, so the qualifier picks the C-locale form of JKAShared.
                if JKAShared.toupper(str1[str1Index + j]) != JKAShared.toupper(str2[j]) { break }
            }
            j += 1
        }
        //if there was a word match
        if str2[j] == 0 {
            //if the first string has an end of word
            if str1[str1Index + j] == 0 || str1[str1Index + j] == Int32(ascii: " ") || str1[str1Index + j] == Int32(ascii: ".") || str1[str1Index + j] == Int32(ascii: ",") || str1[str1Index + j] == Int32(ascii: "!") { return String(str1[str1Index...]) }
        }
        i += 1
        str1Index += 1
    }
    return nil
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:520
// Port-note: StringContainsWord returns the text at its pointer as a `String?`, and this body compares and steps that pointer inside `string`, row P15 of the bot-ai round.
func StringReplaceWords(_ string: inout JKAShared.CharBuf, _ synonym: String, _ replacement: String) {
    // TODO: Port StringReplaceWords
    portMissing("StringReplaceWords", source: "oracle/codemp/botlib/be_ai_chat.cpp:520")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:553
// Port-note: Only a comment at be_ai_chat.cpp:733 calls this function, so it is dead, rule 20.
func BotDumpSynonymList(_ synlist: BotSynonymlist) {
    // TODO: Port BotDumpSynonymList
    portMissing("BotDumpSynonymList", source: "oracle/codemp/botlib/be_ai_chat.cpp:553")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:578
// Port-note: Raven cuts one GetClearedHunkMemory block into the synonym lists, the synonyms, and their texts (D12 shape 11), and no form exists, row P3 of the bot-ai round.
func BotLoadSynonyms(_ filename: inout JKAShared.CharBuf) -> BotSynonymlist? {
    // TODO: Port BotLoadSynonyms
    portMissing("BotLoadSynonyms", source: "oracle/codemp/botlib/be_ai_chat.cpp:578")
}

//===========================================================================
// replace all the synonyms in the string
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:744
func BotReplaceSynonyms(_ string: inout JKAShared.CharBuf, _ context: UInt32) {
    var syn: BotSynonymlist?
    var synonym: BotSynonym?

    syn = synonyms
    while syn != nil {
        if (syn!.context & context) == 0 {
            syn = syn!.next
            continue
        }
        synonym = syn!.firstsynonym!.next
        while synonym != nil {
            StringReplaceWords(&string, synonym!.string!, syn!.firstsynonym!.string!)
            synonym = synonym!.next
        }
        syn = syn!.next
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:764
func BotReplaceWeightedSynonyms(_ string: inout JKAShared.CharBuf, _ context: UInt32) {
    var syn: BotSynonymlist?
    var synonym: BotSynonym?
    var replacement: BotSynonym?
    var weight: Float
    var curweight: Float

    syn = synonyms
    while syn != nil {
        if (syn!.context & context) == 0 {
            syn = syn!.next
            continue
        }
        //choose a weighted random replacement synonym
        weight = random() * syn!.totalweight
        if weight == 0 {
            syn = syn!.next
            continue
        }
        curweight = 0
        replacement = syn!.firstsynonym
        while replacement != nil {
            curweight += replacement!.weight
            if weight < curweight { break }
            replacement = replacement!.next
        }
        if replacement == nil {
            syn = syn!.next
            continue
        }
        //replace all synonyms with the replacement
        synonym = syn!.firstsynonym
        while synonym != nil {
            if synonym == replacement {
                synonym = synonym!.next
                continue
            }
            StringReplaceWords(&string, synonym!.string!, replacement!.string!)
            synonym = synonym!.next
        }
        syn = syn!.next
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:797
// Port-note: StringContainsWord returns the text at its pointer as a `String?`, and this body compares that pointer with `str1`, row P15 of the bot-ai round.
func BotReplaceReplySynonyms(_ string: inout JKAShared.CharBuf, _ context: UInt32) {
    // TODO: Port BotReplaceReplySynonyms
    portMissing("BotReplaceReplySynonyms", source: "oracle/codemp/botlib/be_ai_chat.cpp:797")
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:845
func BotLoadChatMessage(_ source: Source, _ chatmessagestring: inout JKAShared.CharBuf) -> Int32 {
    Token.scratch { token -> Int32 in
        var ptr: Int32

        ptr = 0
        chatmessagestring[ptr] = 0
        //
        while true {
            if PC_ExpectAnyToken(source, token) == 0 { return 0 }
            //fixed string
            if token.type == TT_STRING {
                StripDoubleQuotes(&token.stringBuffer)
                if strlen(chatmessagestring[ptr...]) + strlen(token.string) + 1 > MAX_MESSAGE_SIZE {
                    SourceError(source, "chat message too long\n")
                    return 0
                }
                strcat(&chatmessagestring, token.string, at: ptr)
            }
            //variable string
            else if token.type == TT_NUMBER && (token.subtype & TT_INTEGER) != 0 {
                if strlen(chatmessagestring[ptr...]) + 7 > MAX_MESSAGE_SIZE {
                    SourceError(source, "chat message too long\n")
                    return 0
                }
                // Port-note: The `%ld` of this format is outside the format subset of Format.swift, row P16 of the bot-ai round.
                // Raven wrote: sprintf(&ptr[strlen(ptr)], "%cv%ld%c", ESCAPE_CHAR, token.intvalue, ESCAPE_CHAR);
                portMissing("BotLoadChatMessage", source: "oracle/codemp/botlib/be_ai_chat.cpp:845")
            }
            //random string
            else if token.type == TT_NAME {
                if strlen(chatmessagestring[ptr...]) + 7 > MAX_MESSAGE_SIZE {
                    SourceError(source, "chat message too long\n")
                    return 0
                }
                strcpy(&chatmessagestring, va("%cr%s%c", ESCAPE_CHAR, token.string, ESCAPE_CHAR), at: ptr + strlen(chatmessagestring[ptr...]))
            } else {
                SourceError(source, "unknown message component %s\n", token.string)
                return 0
            }
            if PC_CheckTokenString(source, ";") != 0 { break }
            if PC_ExpectTokenString(source, ",") == 0 { return 0 }
        }
        //
        return 1
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:904
// Port-note: Only a comment at be_ai_chat.cpp:1020 calls this function, so it is dead, rule 20.
func BotDumpRandomStringList(_ randomlist: BotRandomlist) {
    // TODO: Port BotDumpRandomStringList
    portMissing("BotDumpRandomStringList", source: "oracle/codemp/botlib/be_ai_chat.cpp:904")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:929
// Port-note: Raven cuts one GetClearedHunkMemory block into the random lists, the random strings, and their texts (D12 shape 11), and no form exists, row P3 of the bot-ai round.
func BotLoadRandomStrings(_ filename: inout JKAShared.CharBuf) -> BotRandomlist? {
    // TODO: Port BotLoadRandomStrings
    portMissing("BotLoadRandomStrings", source: "oracle/codemp/botlib/be_ai_chat.cpp:929")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:1031
func RandomString(_ name: String) -> String? {
    var random: BotRandomlist?
    var rs: BotRandomstring?
    var i: Int32

    random = randomstrings
    while random != nil {
        if strcmp(random!.string!, name) == 0 {
            // Raven's local `random` hides the function of the same name, which his macro still reaches, so the qualifier picks the function.
            i = Int32(JKAMP_DedLogic.random() * random!.numstrings)
            rs = random!.firstrandomstring
            while rs != nil {
                i -= 1
                if i < 0 { break }
                rs = rs!.next
            }
            if rs != nil {
                return rs!.string
            }
        }
        random = random!.next
    }
    return nil
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:1060
// Port-note: Only a comment at be_ai_chat.cpp:1330 calls this function, so it is dead, rule 20.
func BotDumpMatchTemplates(_ matches: BotMatchtemplate) {
    // TODO: Port BotDumpMatchTemplates
    portMissing("BotDumpMatchTemplates", source: "oracle/codemp/botlib/be_ai_chat.cpp:1060")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:1097
func BotFreeMatchPieces(_ matchpieces: BotMatchpiece) {
    var mp: BotMatchpiece?
    var nextmp: BotMatchpiece?
    var ms: BotMatchstring?
    var nextms: BotMatchstring?

    mp = matchpieces
    while mp != nil {
        nextmp = mp!.next
        if mp!.type == MT_STRING {
            ms = mp!.firststring
            while ms != nil {
                nextms = ms!.next
                FreeMemory(ms!.handle)
                ms = nextms
            }
        }
        FreeMemory(mp!.handle)
        mp = nextmp
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:1122
func BotLoadMatchPieces(_ source: Source, _ endtoken: String) -> BotMatchpiece? {
    Token.scratch { token -> BotMatchpiece? in
        var lastwasvariable: Int32
        var emptystring: Int32
        var matchpiece: BotMatchpiece?
        var firstpiece: BotMatchpiece?
        var lastpiece: BotMatchpiece?
        var matchstring: BotMatchstring?
        var lastmatchstring: BotMatchstring?

        firstpiece = nil
        lastpiece = nil
        //
        lastwasvariable = 0
        //
        while PC_ReadToken(source, token) != 0 {
            if token.type == TT_NUMBER && (token.subtype & TT_INTEGER) != 0 {
                if token.intvalue < 0 || token.intvalue >= MAX_MATCHVARIABLES {
                    SourceError(source, "can't have more than %d match variables\n", MAX_MATCHVARIABLES)
                    FreeSource(source)
                    // Port-note: Raven passes a NULL `firstpiece` here, and the parameter of BotFreeMatchPieces is a non-optional view, row P14 of the bot-ai round.
                    // Raven wrote: BotFreeMatchPieces(firstpiece);
                    portMissing("BotLoadMatchPieces", source: "oracle/codemp/botlib/be_ai_chat.cpp:1122")
                    return nil
                }
                if lastwasvariable != 0 {
                    SourceError(source, "not allowed to have adjacent variables\n")
                    FreeSource(source)
                    BotFreeMatchPieces(firstpiece!)
                    return nil
                }
                lastwasvariable = 1
                //
                matchpiece = BotMatchpiece(GetClearedHunkMemory(UInt32(BotMatchpiece.byteCount)))
                matchpiece!.type = MT_VARIABLE
                // AI: Raven stores the `unsigned long` value into an `int`, and C converts it. The store converts with the bit pattern.
                matchpiece!.variable = Int32(bitPattern: token.intvalue)
                matchpiece!.next = nil
                if lastpiece != nil {
                    lastpiece!.next = matchpiece
                } else {
                    firstpiece = matchpiece
                }
                lastpiece = matchpiece
            } else if token.type == TT_STRING {
                //
                matchpiece = BotMatchpiece(GetClearedHunkMemory(UInt32(BotMatchpiece.byteCount)))
                matchpiece!.firststring = nil
                matchpiece!.type = MT_STRING
                matchpiece!.variable = 0
                matchpiece!.next = nil
                if lastpiece != nil {
                    lastpiece!.next = matchpiece
                } else {
                    firstpiece = matchpiece
                }
                lastpiece = matchpiece
                //
                lastmatchstring = nil
                emptystring = 0
                //
                repeat {
                    if matchpiece!.firststring != nil {
                        if PC_ExpectTokenType(source, TT_STRING, 0, token) == 0 {
                            FreeSource(source)
                            BotFreeMatchPieces(firstpiece!)
                            return nil
                        }
                    }
                    StripDoubleQuotes(&token.stringBuffer)
                    // Port-note: Raven puts the match string record and its text in one block (D12 shape 8), and no form exists in a logic body, row P3 of the bot-ai round.
                    // Raven wrote: matchstring = (bot_matchstring_t *) GetClearedHunkMemory(sizeof(bot_matchstring_t) + strlen(token.string) + 1); matchstring->string = (char *) matchstring + sizeof(bot_matchstring_t); strcpy(matchstring->string, token.string);
                    portMissing("BotLoadMatchPieces", source: "oracle/codemp/botlib/be_ai_chat.cpp:1122")
                    if strlen(token.string) == 0 { emptystring = 1 }
                    matchstring!.next = nil
                    if lastmatchstring != nil {
                        lastmatchstring!.next = matchstring
                    } else {
                        matchpiece!.firststring = matchstring
                    }
                    lastmatchstring = matchstring
                } while PC_CheckTokenString(source, "|") != 0
                //if there was no empty string found
                if emptystring == 0 { lastwasvariable = 0 }
            } else {
                SourceError(source, "invalid token %s\n", token.string)
                FreeSource(source)
                // Port-note: Raven passes a NULL `firstpiece` here, and the parameter of BotFreeMatchPieces is a non-optional view, row P14 of the bot-ai round.
                // Raven wrote: BotFreeMatchPieces(firstpiece);
                portMissing("BotLoadMatchPieces", source: "oracle/codemp/botlib/be_ai_chat.cpp:1122")
                return nil
            }
            if PC_CheckTokenString(source, endtoken) != 0 { break }
            if PC_ExpectTokenString(source, ",") == 0 {
                FreeSource(source)
                BotFreeMatchPieces(firstpiece!)
                return nil
            }
        }
        return firstpiece
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:1224
func BotFreeMatchTemplates(_ mt: BotMatchtemplate) {
    var nextmt: BotMatchtemplate?
    // Raven steps his own `mt` parameter, so the body walks a local of the same name.
    var mt: BotMatchtemplate? = mt

    while mt != nil {
        nextmt = mt!.next
        BotFreeMatchPieces(mt!.first!)
        FreeMemory(mt!.handle)
        mt = nextmt
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:1241
func BotLoadMatchTemplates(_ matchfile: inout JKAShared.CharBuf) -> BotMatchtemplate? {
    Token.scratch { token -> BotMatchtemplate? in
        var matchtemplate: BotMatchtemplate?
        var matches: BotMatchtemplate?
        var lastmatch: BotMatchtemplate?
        var context: UInt32

        PC_SetBaseFolder(BOTFILESBASEFOLDER)
        guard let source = LoadSourceFile(String(matchfile)) else {
            // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
            // Raven wrote: botimport.Print(PRT_ERROR, "counldn't load %s\n", matchfile);
            portMissing("BotLoadMatchTemplates", source: "oracle/codemp/botlib/be_ai_chat.cpp:1241")
            return nil
        }
        //
        matches = nil //list with matches
        lastmatch = nil //last match in the list

        while PC_ReadToken(source, token) != 0 {
            if token.type != TT_NUMBER || (token.subtype & TT_INTEGER) == 0 {
                SourceError(source, "expected integer, found %s\n", token.string)
                // Port-note: Raven passes a NULL `matches` here, and the parameter of BotFreeMatchTemplates is a non-optional view, row P14 of the bot-ai round.
                // Raven wrote: BotFreeMatchTemplates(matches);
                portMissing("BotLoadMatchTemplates", source: "oracle/codemp/botlib/be_ai_chat.cpp:1241")
                FreeSource(source)
                return nil
            }
            //the context
            context = token.intvalue
            //
            if PC_ExpectTokenString(source, "{") == 0 {
                // Port-note: Raven passes a NULL `matches` here, and the parameter of BotFreeMatchTemplates is a non-optional view, row P14 of the bot-ai round.
                // Raven wrote: BotFreeMatchTemplates(matches);
                portMissing("BotLoadMatchTemplates", source: "oracle/codemp/botlib/be_ai_chat.cpp:1241")
                FreeSource(source)
                return nil
            }
            //
            while PC_ReadToken(source, token) != 0 {
                if strcmp(token.string, "}") == 0 { break }
                //
                PC_UnreadLastToken(source)
                //
                matchtemplate = BotMatchtemplate(GetClearedHunkMemory(UInt32(BotMatchtemplate.byteCount)))
                matchtemplate!.context = context
                matchtemplate!.next = nil
                //add the match template to the list
                if lastmatch != nil {
                    lastmatch!.next = matchtemplate
                } else {
                    matches = matchtemplate
                }
                lastmatch = matchtemplate
                //load the match template
                matchtemplate!.first = BotLoadMatchPieces(source, "=")
                if matchtemplate!.first == nil {
                    BotFreeMatchTemplates(matches!)
                    return nil
                }
                //read the match type
                if PC_ExpectTokenString(source, "(") == 0 || PC_ExpectTokenType(source, TT_NUMBER, TT_INTEGER, token) == 0 {
                    BotFreeMatchTemplates(matches!)
                    FreeSource(source)
                    return nil
                }
                // AI: Raven stores the `unsigned long` value into an `int`, and C converts it. The store converts with the bit pattern.
                matchtemplate!.type = Int32(bitPattern: token.intvalue)
                //read the match subtype
                if PC_ExpectTokenString(source, ",") == 0 || PC_ExpectTokenType(source, TT_NUMBER, TT_INTEGER, token) == 0 {
                    BotFreeMatchTemplates(matches!)
                    FreeSource(source)
                    return nil
                }
                // AI: Raven stores the `unsigned long` value into an `int`, and C converts it. The store converts with the bit pattern.
                matchtemplate!.subtype = Int32(bitPattern: token.intvalue)
                //read trailing punctuations
                if PC_ExpectTokenString(source, ")") == 0 || PC_ExpectTokenString(source, ";") == 0 {
                    BotFreeMatchTemplates(matches!)
                    FreeSource(source)
                    return nil
                }
            }
        }
        //free the source
        FreeSource(source)
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_MESSAGE, "loaded %s\n", matchfile);
        portMissing("BotLoadMatchTemplates", source: "oracle/codemp/botlib/be_ai_chat.cpp:1241")
        //
        //BotDumpMatchTemplates(matches);
        //
        return matches
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:1340
func StringsMatch(_ pieces: BotMatchpiece, _ match: BotMatch) -> Int32 {
    var lastvariable: Int32
    var index: Int32
    var strptr: Int32
    var newstrptr: Int32?
    var mp: BotMatchpiece?
    var ms: BotMatchstring?

    //no last variable
    lastvariable = -1
    //pointer to the string to compare the match string with
    strptr = 0
    //Log_Write("match: %s", strptr);
    //compare the string with the current match string
    mp = pieces
    while mp != nil {
        //if it is a piece of string
        if mp!.type == MT_STRING {
            newstrptr = nil
            ms = mp!.firststring
            while ms != nil {
                if strlen(ms!.string!) == 0 {
                    newstrptr = strptr
                    break
                }
                //Log_Write("MT_STRING: %s", mp->string);
                var strptrBuffer = match.stringBuffer[strptr...]
                index = StringContains(&strptrBuffer, ms!.string!, 0)
                if index >= 0 {
                    newstrptr = strptr + index
                    if lastvariable >= 0 {
                        // AI: The view reads the `char offset` field as `Int8`. The read widens it as C does.
                        match.variables[lastvariable].length = newstrptr! - Int32(match.variables[lastvariable].offset)
                        //newstrptr - match->variables[lastvariable].ptr;
                        lastvariable = -1
                        break
                    } else if index == 0 {
                        break
                    }
                    newstrptr = nil
                }
                ms = ms!.next
            }
            if newstrptr == nil { return 0 }
            strptr = newstrptr! + strlen(ms!.string!)
        }
        //if it is a variable piece of string
        else if mp!.type == MT_VARIABLE {
            //Log_Write("MT_VARIABLE");
            match.variables[mp!.variable].offset = Int8(truncatingIfNeeded: strptr)
            lastvariable = mp!.variable
        }
        mp = mp!.next
    }
    //if a match was found
    if mp == nil && (lastvariable >= 0 || strlen(match.stringBuffer[strptr...]) == 0) {
        //if the last piece was a variable string
        if lastvariable >= 0 {
            assert(match.variables[lastvariable].offset >= 0) // bk001204
            match.variables[lastvariable].length = strlen(match.stringBuffer[Int32(match.variables[lastvariable].offset)...])
        }
        return 1
    }
    return 0
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:1417
func BotFindMatch(_ str: String, _ match: BotMatch, _ context: UInt32) -> Int32 {
    var i: Int32
    var ms: BotMatchtemplate?

    strncpy(&match.stringBuffer, str, MAX_MESSAGE_SIZE)
    //remove any trailing enters
    while strlen(match.string) != 0 && match.stringBuffer[strlen(match.string) - 1] == Int32(ascii: "\n") {
        match.stringBuffer[strlen(match.string) - 1] = 0
    }
    //compare the string with all the match strings
    ms = matchtemplates
    while ms != nil {
        if (ms!.context & context) == 0 {
            ms = ms!.next
            continue
        }
        //reset the match variable offsets
        i = 0
        while i < MAX_MATCHVARIABLES {
            match.variables[i].offset = -1
            i += 1
        }
        //
        if StringsMatch(ms!.first!, match) != 0 {
            match.type = ms!.type
            match.subtype = ms!.subtype
            return 1
        }
        ms = ms!.next
    }
    return 0
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:1451
func BotMatchVariable(_ match: BotMatch, _ variable: Int32, _ buf: inout JKAShared.CharBuf, _ size: Int32) {
    // Raven writes his own `size` parameter, so the body writes a local of the same name.
    var size = size

    if variable < 0 || variable >= MAX_MATCHVARIABLES {
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_FATAL, "BotMatchVariable: variable out of range\n");
        portMissing("BotMatchVariable", source: "oracle/codemp/botlib/be_ai_chat.cpp:1451")
        strcpy(&buf, "")
        return
    }

    if match.variables[variable].offset >= 0 {
        if match.variables[variable].length < size {
            size = match.variables[variable].length + 1
        }
        assert(match.variables[variable].offset >= 0) // bk001204
        strncpy(&buf, match.stringBuffer[Int32(match.variables[variable].offset)...], size - 1)
        buf[size - 1] = 0
    } else {
        strcpy(&buf, "")
    }
    return
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:1480
func BotFindStringInList(_ list: BotStringlist, _ string: String) -> BotStringlist? {
    var s: BotStringlist?

    s = list
    while s != nil {
        if strcmp(s!.string!, string) == 0 { return s }
        s = s!.next
    }
    return nil
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:1496
// Port-note: Raven passes a NULL `stringlist`, and the parameter is a non-optional view, row P14 of the bot-ai round.
// Port-note: Raven puts the string list record and its text in one block (D12 shape 8), and no form exists in a logic body, row P3 of the bot-ai round.
func BotCheckChatMessageIntegrety(_ message: inout JKAShared.CharBuf, _ stringlist: BotStringlist) -> BotStringlist? {
    // TODO: Port BotCheckChatMessageIntegrety
    portMissing("BotCheckChatMessageIntegrety", source: "oracle/codemp/botlib/be_ai_chat.cpp:1496")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:1567
// Port-note: Raven passes the NULL `stringlist` to BotCheckChatMessageIntegrety, whose parameter is a non-optional view, row P14 of the bot-ai round.
func BotCheckInitialChatIntegrety(_ chat: BotChat) {
    // TODO: Port BotCheckInitialChatIntegrety
    portMissing("BotCheckInitialChatIntegrety", source: "oracle/codemp/botlib/be_ai_chat.cpp:1567")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:1593
// Port-note: Raven passes the NULL `stringlist` to BotCheckChatMessageIntegrety, whose parameter is a non-optional view, row P14 of the bot-ai round.
func BotCheckReplyChatIntegrety(_ replychat: BotReplychat) {
    // TODO: Port BotCheckReplyChatIntegrety
    portMissing("BotCheckReplyChatIntegrety", source: "oracle/codemp/botlib/be_ai_chat.cpp:1593")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:1619
// Port-note: Only a comment at be_ai_chat.cpp:1955 calls this function, so it is dead, rule 20.
func BotDumpReplyChat(_ replychat: BotReplychat) {
    // TODO: Port BotDumpReplyChat
    portMissing("BotDumpReplyChat", source: "oracle/codemp/botlib/be_ai_chat.cpp:1619")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:1674
func BotFreeReplyChat(_ replychat: BotReplychat) {
    var rp: BotReplychat?
    var nextrp: BotReplychat?
    var key: BotReplychatkey?
    var nextkey: BotReplychatkey?
    var cm: BotChatmessage?
    var nextcm: BotChatmessage?

    rp = replychat
    while rp != nil {
        nextrp = rp!.next
        key = rp!.keys
        while key != nil {
            nextkey = key!.next
            if key!.match != nil { BotFreeMatchPieces(key!.match!) }
            // AI: Raven frees the GetMemory block of the text. The field holds a pooled text, so the free drops.
            FreeMemory(key!.handle)
            key = nextkey
        }
        cm = rp!.firstchatmessage
        while cm != nil {
            nextcm = cm!.next
            FreeMemory(cm!.handle)
            cm = nextcm
        }
        FreeMemory(rp!.handle)
        rp = nextrp
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:1704
func BotCheckValidReplyChatKeySet(_ source: Source, _ keys: BotReplychatkey) {
    var allprefixed: Int32
    var hasvariableskey: Int32
    var hasstringkey: Int32
    var m: BotMatchpiece?
    var ms: BotMatchstring?
    var key: BotReplychatkey?
    var key2: BotReplychatkey?

    //
    allprefixed = 1
    hasstringkey = 0
    hasvariableskey = hasstringkey
    key = keys
    while key != nil {
        if (key!.flags & (RCKFL_AND | RCKFL_NOT)) == 0 {
            allprefixed = 0
            if (key!.flags & RCKFL_VARIABLES) != 0 {
                m = key!.match
                while m != nil {
                    if m!.type == MT_VARIABLE { hasvariableskey = 1 }
                    m = m!.next
                }
            } else if (key!.flags & RCKFL_STRING) != 0 {
                hasstringkey = 1
            }
        } else if (key!.flags & RCKFL_AND) != 0 && (key!.flags & RCKFL_STRING) != 0 {
            key2 = keys
            while key2 != nil {
                if key2 == key {
                    key2 = key2!.next
                    continue
                }
                if (key2!.flags & RCKFL_NOT) != 0 {
                    key2 = key2!.next
                    continue
                }
                if (key2!.flags & RCKFL_VARIABLES) != 0 {
                    m = key2!.match
                    while m != nil {
                        if m!.type == MT_STRING {
                            ms = m!.firststring
                            while ms != nil {
                                var msString = CharBuf(ms!.string!)
                                if StringContains(&msString, key!.string!, 0) != -1 {
                                    break
                                }
                                ms = ms!.next
                            }
                            if ms != nil { break }
                        } else if m!.type == MT_VARIABLE {
                            break
                        }
                        m = m!.next
                    }
                    if m == nil {
                        SourceWarning(source, "one of the match templates does not leave space for the key %s with the & prefix", key!.string ?? "(null)")
                    }
                }
                key2 = key2!.next
            }
        }
        if (key!.flags & RCKFL_NOT) != 0 && (key!.flags & RCKFL_STRING) != 0 {
            key2 = keys
            while key2 != nil {
                if key2 == key {
                    key2 = key2!.next
                    continue
                }
                if (key2!.flags & RCKFL_NOT) != 0 {
                    key2 = key2!.next
                    continue
                }
                if (key2!.flags & RCKFL_STRING) != 0 {
                    var key2String = CharBuf(key2!.string!)
                    if StringContains(&key2String, key!.string!, 0) != -1 {
                        SourceWarning(source, "the key %s with prefix ! is inside the key %s", key!.string ?? "(null)", key2!.string ?? "(null)")
                    }
                } else if (key2!.flags & RCKFL_VARIABLES) != 0 {
                    m = key2!.match
                    while m != nil {
                        if m!.type == MT_STRING {
                            ms = m!.firststring
                            while ms != nil {
                                var msString = CharBuf(ms!.string!)
                                if StringContains(&msString, key!.string!, 0) != -1 {
                                    SourceWarning(source, "the key %s with prefix ! is inside the match template string %s", key!.string ?? "(null)", ms!.string ?? "(null)")
                                }
                                ms = ms!.next
                            }
                        }
                        m = m!.next
                    }
                }
                key2 = key2!.next
            }
        }
        key = key!.next
    }
    if allprefixed != 0 { SourceWarning(source, "all keys have a & or ! prefix") }
    if hasvariableskey != 0 && hasstringkey != 0 {
        SourceWarning(source, "variables from the match template(s) could be invalid when outputting one of the chat messages")
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:1811
func BotLoadReplyChat(_ filename: inout JKAShared.CharBuf) -> BotReplychat? {
    Token.scratch { token -> BotReplychat? in
        var chatmessagestring = CharBuf(MAX_MESSAGE_SIZE)
        var namebuffer = CharBuf(MAX_MESSAGE_SIZE)
        var chatmessage: BotChatmessage? = nil
        var replychat: BotReplychat?
        var replychatlist: BotReplychat?
        var key: BotReplychatkey?

        PC_SetBaseFolder(BOTFILESBASEFOLDER)
        guard let source = LoadSourceFile(String(filename)) else {
            // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
            // Raven wrote: botimport.Print(PRT_ERROR, "counldn't load %s\n", filename);
            portMissing("BotLoadReplyChat", source: "oracle/codemp/botlib/be_ai_chat.cpp:1811")
            return nil
        }
        //
        replychatlist = nil
        //
        while PC_ReadToken(source, token) != 0 {
            if strcmp(token.string, "[") != 0 {
                SourceError(source, "expected [, found %s", token.string)
                // Port-note: Raven passes a NULL `replychatlist` here, and the parameter of BotFreeReplyChat is a non-optional view, row P14 of the bot-ai round.
                // Raven wrote: BotFreeReplyChat(replychatlist);
                portMissing("BotLoadReplyChat", source: "oracle/codemp/botlib/be_ai_chat.cpp:1811")
                FreeSource(source)
                return nil
            }
            //
            replychat = BotReplychat(GetClearedHunkMemory(UInt32(BotReplychat.byteCount)))
            replychat!.keys = nil
            replychat!.next = replychatlist
            replychatlist = replychat
            //read the keys, there must be at least one key
            repeat {
                //allocate a key
                key = BotReplychatkey(GetClearedHunkMemory(UInt32(BotReplychatkey.byteCount)))
                key!.flags = 0
                key!.string = nil
                key!.match = nil
                key!.next = replychat!.keys
                replychat!.keys = key
                //check for MUST BE PRESENT and MUST BE ABSENT keys
                if PC_CheckTokenString(source, "&") != 0 {
                    key!.flags |= RCKFL_AND
                } else if PC_CheckTokenString(source, "!") != 0 {
                    key!.flags |= RCKFL_NOT
                }
                //special keys
                if PC_CheckTokenString(source, "name") != 0 {
                    key!.flags |= RCKFL_NAME
                } else if PC_CheckTokenString(source, "female") != 0 {
                    key!.flags |= RCKFL_GENDERFEMALE
                } else if PC_CheckTokenString(source, "male") != 0 {
                    key!.flags |= RCKFL_GENDERMALE
                } else if PC_CheckTokenString(source, "it") != 0 {
                    key!.flags |= RCKFL_GENDERLESS
                } else if PC_CheckTokenString(source, "(") != 0 { //match key
                    key!.flags |= RCKFL_VARIABLES
                    key!.match = BotLoadMatchPieces(source, ")")
                    if key!.match == nil {
                        BotFreeReplyChat(replychatlist!)
                        return nil
                    }
                } else if PC_CheckTokenString(source, "<") != 0 { //bot names
                    key!.flags |= RCKFL_BOTNAMES
                    strcpy(&namebuffer, "")
                    repeat {
                        if PC_ExpectTokenType(source, TT_STRING, 0, token) == 0 {
                            BotFreeReplyChat(replychatlist!)
                            FreeSource(source)
                            return nil
                        }
                        StripDoubleQuotes(&token.stringBuffer)
                        if strlen(namebuffer) != 0 { strcat(&namebuffer, "\\") }
                        strcat(&namebuffer, token.string)
                    } while PC_CheckTokenString(source, ",") != 0
                    if PC_ExpectTokenString(source, ">") == 0 {
                        BotFreeReplyChat(replychatlist!)
                        FreeSource(source)
                        return nil
                    }
                    // AI: Raven copies the text into a GetMemory block. The call stays for the zone count, and the field takes the text.
                    _ = GetClearedHunkMemory(UInt32(strlen(namebuffer) + 1))
                    key!.string = String(namebuffer)
                } else { //normal string key
                    key!.flags |= RCKFL_STRING
                    if PC_ExpectTokenType(source, TT_STRING, 0, token) == 0 {
                        BotFreeReplyChat(replychatlist!)
                        FreeSource(source)
                        return nil
                    }
                    StripDoubleQuotes(&token.stringBuffer)
                    // AI: Raven copies the text into a GetMemory block. The call stays for the zone count, and the field takes the text.
                    _ = GetClearedHunkMemory(UInt32(strlen(token.string) + 1))
                    key!.string = token.string
                }
                //
                PC_CheckTokenString(source, ",")
            } while PC_CheckTokenString(source, "]") == 0
            //
            BotCheckValidReplyChatKeySet(source, replychat!.keys!)
            //read the = sign and the priority
            if PC_ExpectTokenString(source, "=") == 0 || PC_ExpectTokenType(source, TT_NUMBER, 0, token) == 0 {
                BotFreeReplyChat(replychatlist!)
                FreeSource(source)
                return nil
            }
            replychat!.priority = Float(token.floatvalue)
            //read the leading {
            if PC_ExpectTokenString(source, "{") == 0 {
                BotFreeReplyChat(replychatlist!)
                FreeSource(source)
                return nil
            }
            replychat!.numchatmessages = 0
            //while the trailing } is not found
            while PC_CheckTokenString(source, "}") == 0 {
                if BotLoadChatMessage(source, &chatmessagestring) == 0 {
                    BotFreeReplyChat(replychatlist!)
                    FreeSource(source)
                    return nil
                }
                // Port-note: Raven puts the chat message record and its text in one block (D12 shape 8), and no form exists in a logic body, row P3 of the bot-ai round.
                // Raven wrote: chatmessage = (bot_chatmessage_t *) GetClearedHunkMemory(sizeof(bot_chatmessage_t) + strlen(chatmessagestring) + 1); chatmessage->chatmessage = (char *) chatmessage + sizeof(bot_chatmessage_t); strcpy(chatmessage->chatmessage, chatmessagestring);
                portMissing("BotLoadReplyChat", source: "oracle/codemp/botlib/be_ai_chat.cpp:1811")
                chatmessage!.time = Float(-2 * CHATMESSAGE_RECENTTIME)
                chatmessage!.next = replychat!.firstchatmessage
                //add the chat message to the reply chat
                replychat!.firstchatmessage = chatmessage
                replychat!.numchatmessages += 1
            }
        }
        FreeSource(source)
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_MESSAGE, "loaded %s\n", filename);
        portMissing("BotLoadReplyChat", source: "oracle/codemp/botlib/be_ai_chat.cpp:1811")
        //
        //BotDumpReplyChat(replychatlist);
        if bot_developer != 0 {
            // Port-note: Raven passes a NULL `replychatlist` here when the file holds no reply chat, and the parameter of BotCheckReplyChatIntegrety is a non-optional view, row P14 of the bot-ai round.
            // Raven wrote: BotCheckReplyChatIntegrety(replychatlist);
            portMissing("BotLoadReplyChat", source: "oracle/codemp/botlib/be_ai_chat.cpp:1811")
        }
        //
        if replychatlist == nil {
            // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
            // Raven wrote: botimport.Print(PRT_MESSAGE, "no rchats\n");
            portMissing("BotLoadReplyChat", source: "oracle/codemp/botlib/be_ai_chat.cpp:1811")
        }
        //
        return replychatlist
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:1971
// Port-note: Only a comment at be_ai_chat.cpp:2151 calls this function, so it is dead, rule 20.
func BotDumpInitialChat(_ chat: BotChat) {
    // TODO: Port BotDumpInitialChat
    portMissing("BotDumpInitialChat", source: "oracle/codemp/botlib/be_ai_chat.cpp:1971")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:1996
// Port-note: Raven cuts one GetClearedMemory block into the chat, the chat types, the chat messages, and their texts (D12 shape 11), and no form exists, row P3 of the bot-ai round.
func BotLoadInitialChat(_ chatfile: inout JKAShared.CharBuf, _ chatname: inout JKAShared.CharBuf) -> BotChat? {
    // TODO: Port BotLoadInitialChat
    portMissing("BotLoadInitialChat", source: "oracle/codemp/botlib/be_ai_chat.cpp:1996")
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:2168
func BotFreeChatFile(_ chatstate: Int32) {
    guard let cs = BotChatStateFromHandle(chatstate) else { return }
    if cs.chat != nil { FreeMemory(cs.chat!.handle) }
    cs.chat = nil
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:2183
func BotLoadChatFile(_ chatstate: Int32, _ chatfile: inout JKAShared.CharBuf, _ chatname: inout JKAShared.CharBuf) -> Int32 {
    var n: Int32
    var avail: Int32 = 0

    guard let cs = BotChatStateFromHandle(chatstate) else { return BLERR_CANNOTLOADICHAT }
    BotFreeChatFile(chatstate)

    if LibVarGetValue("bot_reloadcharacters") == 0 {
        avail = -1
        n = 0
        while n < MAX_CLIENTS {
            if ichatdata[n] == nil {
                if avail == -1 {
                    avail = n
                }
                n += 1
                continue
            }
            if strcmp(chatfile, ichatdata[n]!.filename) != 0 {
                n += 1
                continue
            }
            if strcmp(chatname, ichatdata[n]!.chatname) != 0 {
                n += 1
                continue
            }
            cs.chat = ichatdata[n]!.chat
            //		botimport.Print( PRT_MESSAGE, "retained %s from %s\n", chatname, chatfile );
            return BLERR_NOERROR
        }

        if avail == -1 {
            // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
            // Raven wrote: botimport.Print(PRT_FATAL, "ichatdata table full; couldn't load chat %s from %s\n", chatname, chatfile);
            portMissing("BotLoadChatFile", source: "oracle/codemp/botlib/be_ai_chat.cpp:2183")
            return BLERR_CANNOTLOADICHAT
        }
    }

    cs.chat = BotLoadInitialChat(&chatfile, &chatname)
    if cs.chat == nil {
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_FATAL, "couldn't load chat %s from %s\n", chatname, chatfile);
        portMissing("BotLoadChatFile", source: "oracle/codemp/botlib/be_ai_chat.cpp:2183")
        return BLERR_CANNOTLOADICHAT
    }
    if LibVarGetValue("bot_reloadcharacters") == 0 {
        ichatdata[avail] = BotIchatdata(GetClearedMemory(UInt32(BotIchatdata.byteCount)))
        ichatdata[avail]!.chat = cs.chat
        Q_strncpyz(&ichatdata[avail]!.chatnameBuffer, String(chatname), MAX_QPATH)
        Q_strncpyz(&ichatdata[avail]!.filenameBuffer, String(chatfile), MAX_QPATH)
    }

    return BLERR_NOERROR
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:2241
func BotExpandChatMessage(_ outmessage: inout JKAShared.CharBuf, _ message: inout JKAShared.CharBuf, _ mcontext: UInt32, _ match: BotMatch, _ vcontext: UInt32, _ reply: Int32) -> Int32 {
    var num: Int32
    var len: Int32
    var i: Int32
    var expansion: Int32
    var msgptr: Int32
    var temp = CharBuf(MAX_MESSAGE_SIZE)

    expansion = 0
    msgptr = 0
    // AI: Raven writes through `outputbuf`, a copy of the `outmessage` pointer. The body writes `outmessage` itself.
    len = 0
    //
    while message[msgptr] != 0 {
        if message[msgptr] == ESCAPE_CHAR {
            msgptr += 1
            switch message[msgptr] as Int32 {
            case Int32(ascii: "v"): //variable
                msgptr += 1
                num = 0
                while message[msgptr] != 0 && message[msgptr] != ESCAPE_CHAR {
                    num = num * 10 + (message[msgptr] as Int32) - Int32(ascii: "0")
                    msgptr += 1
                }
                //step over the trailing escape char
                if message[msgptr] != 0 { msgptr += 1 }
                if num > MAX_MATCHVARIABLES {
                    // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
                    // Raven wrote: botimport.Print(PRT_ERROR, "BotConstructChat: message %s variable %d out of range\n", message, num);
                    portMissing("BotExpandChatMessage", source: "oracle/codemp/botlib/be_ai_chat.cpp:2241")
                    return 0
                }
                // Port-note: Raven's test lets `num` reach MAX_MATCHVARIABLES, and he reads `variables[8]` past the array there.
                // Port-note: The Slots subscript traps at that index, rule 19.
                if match.variables[num].offset >= 0 {
                    assert(match.variables[num].offset >= 0) // bk001204
                    let ptr = Int32(match.variables[num].offset)
                    i = 0
                    while i < match.variables[num].length {
                        temp[i] = match.stringBuffer[ptr + i]
                        i += 1
                    }
                    temp[i] = 0
                    //if it's a reply message
                    if reply != 0 {
                        //replace the reply synonyms in the variables
                        BotReplaceReplySynonyms(&temp, vcontext)
                    } else {
                        //replace synonyms in the variable context
                        BotReplaceSynonyms(&temp, vcontext)
                    }
                    //
                    if len + strlen(temp) >= MAX_MESSAGE_SIZE {
                        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
                        // Raven wrote: botimport.Print(PRT_ERROR, "BotConstructChat: message %s too long\n", message);
                        portMissing("BotExpandChatMessage", source: "oracle/codemp/botlib/be_ai_chat.cpp:2241")
                        return 0
                    }
                    strcpy(&outmessage, temp, at: len)
                    len += strlen(temp)
                }
            case Int32(ascii: "r"): //random
                msgptr += 1
                i = 0
                while message[msgptr] != 0 && message[msgptr] != ESCAPE_CHAR {
                    temp[i] = message[msgptr]
                    msgptr += 1
                    i += 1
                }
                temp[i] = 0
                //step over the trailing escape char
                if message[msgptr] != 0 { msgptr += 1 }
                //find the random keyword
                let ptr = RandomString(String(temp))
                if ptr == nil {
                    // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
                    // Raven wrote: botimport.Print(PRT_ERROR, "BotConstructChat: unknown random string %s\n", temp);
                    portMissing("BotExpandChatMessage", source: "oracle/codemp/botlib/be_ai_chat.cpp:2241")
                    return 0
                }
                if len + strlen(ptr!) >= MAX_MESSAGE_SIZE {
                    // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
                    // Raven wrote: botimport.Print(PRT_ERROR, "BotConstructChat: message \"%s\" too long\n", message);
                    portMissing("BotExpandChatMessage", source: "oracle/codemp/botlib/be_ai_chat.cpp:2241")
                    return 0
                }
                strcpy(&outmessage, ptr!, at: len)
                len += strlen(ptr!)
                expansion = 1
            default:
                // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
                // Raven wrote: botimport.Print(PRT_FATAL, "BotConstructChat: message \"%s\" invalid escape char\n", message);
                portMissing("BotExpandChatMessage", source: "oracle/codemp/botlib/be_ai_chat.cpp:2241")
            }
        } else {
            outmessage[len] = message[msgptr]
            len += 1
            msgptr += 1
            if len >= MAX_MESSAGE_SIZE {
                // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
                // Raven wrote: botimport.Print(PRT_ERROR, "BotConstructChat: message \"%s\" too long\n", message);
                portMissing("BotExpandChatMessage", source: "oracle/codemp/botlib/be_ai_chat.cpp:2241")
                break
            }
        }
    }
    outmessage[len] = 0
    //replace synonyms weighted in the message context
    BotReplaceWeightedSynonyms(&outmessage, mcontext)
    //return true if a random was expanded
    return expansion
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:2362
func BotConstructChatMessage(_ chatstate: BotChatstate, _ message: String, _ mcontext: UInt32, _ match: BotMatch, _ vcontext: UInt32, _ reply: Int32) {
    var i: Int32
    var srcmessage = CharBuf(MAX_MESSAGE_SIZE)

    strcpy(&srcmessage, message)
    i = 0
    while i < 10 {
        if BotExpandChatMessage(&chatstate.chatmessageBuffer, &srcmessage, mcontext, match, vcontext, reply) == 0 {
            break
        }
        strcpy(&srcmessage, chatstate.chatmessageBuffer)
        i += 1
    }
    if i >= 10 {
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_WARNING, "too many expansions in chat message\n"); botimport.Print(PRT_WARNING, "%s\n", chatstate->chatmessage);
        portMissing("BotConstructChatMessage", source: "oracle/codemp/botlib/be_ai_chat.cpp:2362")
    }
}

//===========================================================================
// randomly chooses one of the chat message of the given type
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:2390
func BotChooseInitialChatMessage(_ cs: BotChatstate, _ type: String) -> String? {
    var n: Int32
    var numchatmessages: Int32
    var besttime: Float
    var t: BotChattype?
    var m: BotChatmessage?
    var bestchatmessage: BotChatmessage?
    var chat: BotChat?

    chat = cs.chat
    t = chat!.types
    while t != nil {
        if Q_stricmp(t!.name, type) == 0 {
            numchatmessages = 0
            m = t!.firstchatmessage
            while m != nil {
                if m!.time > AAS_Time() {
                    m = m!.next
                    continue
                }
                numchatmessages += 1
                m = m!.next
            }
            //if all chat messages have been used recently
            if numchatmessages <= 0 {
                besttime = 0
                bestchatmessage = nil
                m = t!.firstchatmessage
                while m != nil {
                    if besttime == 0 || m!.time < besttime {
                        bestchatmessage = m
                        besttime = m!.time
                    }
                    m = m!.next
                }
                if bestchatmessage != nil { return bestchatmessage!.chatmessage }
            } else { //choose a chat message randomly
                n = Int32(random() * numchatmessages)
                m = t!.firstchatmessage
                while m != nil {
                    if m!.time > AAS_Time() {
                        m = m!.next
                        continue
                    }
                    n -= 1
                    if n < 0 {
                        m!.time = AAS_Time() + CHATMESSAGE_RECENTTIME
                        return m!.chatmessage
                    }
                    m = m!.next
                }
            }
            return nil
        }
        t = t!.next
    }
    return nil
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:2448
func BotNumInitialChats(_ chatstate: Int32, _ type: inout JKAShared.CharBuf) -> Int32 {
    var t: BotChattype?

    guard let cs = BotChatStateFromHandle(chatstate) else { return 0 }

    t = cs.chat!.types
    while t != nil {
        if Q_stricmp(t!.name, String(type)) == 0 {
            if LibVarGetValue("bot_testichat") != 0 {
                // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
                // Raven wrote: botimport.Print(PRT_MESSAGE, "%s has %d chat lines\n", type, t->numchatmessages); botimport.Print(PRT_MESSAGE, "-------------------\n");
                portMissing("BotNumInitialChats", source: "oracle/codemp/botlib/be_ai_chat.cpp:2448")
            }
            return t!.numchatmessages
        }
        t = t!.next
    }
    return 0
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:2475
func BotInitialChat(_ chatstate: Int32, _ type: String, _ mcontext: Int32, _ var0: String, _ var1: String, _ var2: String, _ var3: String, _ var4: String, _ var5: String, _ var6: String, _ var7: String) {
    var message: String?

    guard let cs = BotChatStateFromHandle(chatstate) else { return }
    //if no chat file is loaded
    if cs.chat == nil { return }
    //choose a chat message randomly of the given type
    message = BotChooseInitialChatMessage(cs, type)
    //if there's no message of the given type
    if message == nil {
        return
    }
    //
    BotMatch.scratch { match in
        var index: Int32

        index = 0
        strcat(&match.stringBuffer, var0)
        match.variables[0].offset = Int8(truncatingIfNeeded: index)
        match.variables[0].length = strlen(var0)
        index += strlen(var0)
        strcat(&match.stringBuffer, var1)
        match.variables[1].offset = Int8(truncatingIfNeeded: index)
        match.variables[1].length = strlen(var1)
        index += strlen(var1)
        strcat(&match.stringBuffer, var2)
        match.variables[2].offset = Int8(truncatingIfNeeded: index)
        match.variables[2].length = strlen(var2)
        index += strlen(var2)
        strcat(&match.stringBuffer, var3)
        match.variables[3].offset = Int8(truncatingIfNeeded: index)
        match.variables[3].length = strlen(var3)
        index += strlen(var3)
        strcat(&match.stringBuffer, var4)
        match.variables[4].offset = Int8(truncatingIfNeeded: index)
        match.variables[4].length = strlen(var4)
        index += strlen(var4)
        strcat(&match.stringBuffer, var5)
        match.variables[5].offset = Int8(truncatingIfNeeded: index)
        match.variables[5].length = strlen(var5)
        index += strlen(var5)
        strcat(&match.stringBuffer, var6)
        match.variables[6].offset = Int8(truncatingIfNeeded: index)
        match.variables[6].length = strlen(var6)
        index += strlen(var6)
        strcat(&match.stringBuffer, var7)
        match.variables[7].offset = Int8(truncatingIfNeeded: index)
        match.variables[7].length = strlen(var7)
        index += strlen(var7)
        //
        // AI: Raven passes the `int` mcontext to an `unsigned long` parameter, and C converts it. The call converts with the bit pattern.
        BotConstructChatMessage(cs, message!, UInt32(bitPattern: mcontext), match, 0, 0)
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:2556
// Port-note: No code calls this function, so it is dead, rule 20.
func BotPrintReplyChatKeys(_ replychat: BotReplychat) {
    // TODO: Port BotPrintReplyChatKeys
    portMissing("BotPrintReplyChatKeys", source: "oracle/codemp/botlib/be_ai_chat.cpp:2556")
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:2597
func BotReplyChat(_ chatstate: Int32, _ message: inout JKAShared.CharBuf, _ mcontext: Int32, _ vcontext: Int32, _ var0: String, _ var1: String, _ var2: String, _ var3: String, _ var4: String, _ var5: String, _ var6: String, _ var7: String) -> Int32 {
    guard let cs = BotChatStateFromHandle(chatstate) else { return 0 }
    return BotMatch.scratch { match -> Int32 in
        BotMatch.scratch { bestmatch -> Int32 in
            var rchat: BotReplychat?
            var bestrchat: BotReplychat?
            var key: BotReplychatkey?
            var m: BotChatmessage?
            var bestchatmessage: BotChatmessage?
            var bestpriority: Int32
            var num: Int32
            var found: Int32
            var res: Int32
            var numchatmessages: Int32
            var index: Int32

            strcpy(&match.stringBuffer, message)
            bestpriority = -1
            bestchatmessage = nil
            bestrchat = nil
            //go through all the reply chats
            rchat = replychats
            while rchat != nil {
                found = 0
                key = rchat!.keys
                while key != nil {
                    res = 0
                    //get the match result
                    if (key!.flags & RCKFL_NAME) != 0 {
                        res = (StringContains(&message, cs.name, 0) != -1) ? 1 : 0
                    } else if (key!.flags & RCKFL_BOTNAMES) != 0 {
                        var keyString = CharBuf(key!.string!)
                        res = (StringContains(&keyString, cs.name, 0) != -1) ? 1 : 0
                    } else if (key!.flags & RCKFL_GENDERFEMALE) != 0 {
                        res = (cs.gender == CHAT_GENDERFEMALE) ? 1 : 0
                    } else if (key!.flags & RCKFL_GENDERMALE) != 0 {
                        res = (cs.gender == CHAT_GENDERMALE) ? 1 : 0
                    } else if (key!.flags & RCKFL_GENDERLESS) != 0 {
                        res = (cs.gender == CHAT_GENDERLESS) ? 1 : 0
                    } else if (key!.flags & RCKFL_VARIABLES) != 0 {
                        res = StringsMatch(key!.match!, match)
                    } else if (key!.flags & RCKFL_STRING) != 0 {
                        res = (StringContainsWord(&message, key!.string!, 0) != nil) ? 1 : 0
                    }
                    //if the key must be present
                    if (key!.flags & RCKFL_AND) != 0 {
                        if res == 0 {
                            found = 0
                            break
                        }
                    }
                    //if the key must be absent
                    else if (key!.flags & RCKFL_NOT) != 0 {
                        if res != 0 {
                            found = 0
                            break
                        }
                    } else if res != 0 {
                        found = 1
                    }
                    key = key!.next
                }
                //
                if found != 0 {
                    if rchat!.priority > bestpriority {
                        numchatmessages = 0
                        m = rchat!.firstchatmessage
                        while m != nil {
                            if m!.time > AAS_Time() {
                                m = m!.next
                                continue
                            }
                            numchatmessages += 1
                            m = m!.next
                        }
                        num = Int32(random() * numchatmessages)
                        m = rchat!.firstchatmessage
                        while m != nil {
                            num -= 1
                            if num < 0 { break }
                            if m!.time > AAS_Time() {
                                m = m!.next
                                continue
                            }
                            m = m!.next
                        }
                        //if the reply chat has a message
                        if m != nil {
                            bestmatch.copy(from: match)
                            bestchatmessage = m
                            bestrchat = rchat
                            bestpriority = Int32(rchat!.priority)
                        }
                    }
                }
                rchat = rchat!.next
            }
            if bestchatmessage != nil {
                index = strlen(bestmatch.string)
                strcat(&bestmatch.stringBuffer, var0)
                bestmatch.variables[0].offset = Int8(truncatingIfNeeded: index)
                bestmatch.variables[0].length = strlen(var0)
                index += strlen(var0)
                strcat(&bestmatch.stringBuffer, var1)
                bestmatch.variables[1].offset = Int8(truncatingIfNeeded: index)
                bestmatch.variables[1].length = strlen(var1)
                index += strlen(var1)
                strcat(&bestmatch.stringBuffer, var2)
                bestmatch.variables[2].offset = Int8(truncatingIfNeeded: index)
                bestmatch.variables[2].length = strlen(var2)
                index += strlen(var2)
                strcat(&bestmatch.stringBuffer, var3)
                bestmatch.variables[3].offset = Int8(truncatingIfNeeded: index)
                bestmatch.variables[3].length = strlen(var3)
                index += strlen(var3)
                strcat(&bestmatch.stringBuffer, var4)
                bestmatch.variables[4].offset = Int8(truncatingIfNeeded: index)
                bestmatch.variables[4].length = strlen(var4)
                index += strlen(var4)
                strcat(&bestmatch.stringBuffer, var5)
                bestmatch.variables[5].offset = Int8(truncatingIfNeeded: index)
                bestmatch.variables[5].length = strlen(var5)
                index += strlen(var5)
                strcat(&bestmatch.stringBuffer, var6)
                bestmatch.variables[6].offset = Int8(truncatingIfNeeded: index)
                bestmatch.variables[6].length = strlen(var6)
                index += strlen(var6)
                strcat(&bestmatch.stringBuffer, var7)
                bestmatch.variables[7].offset = Int8(truncatingIfNeeded: index)
                bestmatch.variables[7].length = strlen(var7)
                index += strlen(var7)
                if LibVarGetValue("bot_testrchat") != 0 {
                    m = bestrchat!.firstchatmessage
                    while m != nil {
                        // AI: Raven passes the `int` contexts to `unsigned long` parameters, and C converts them. The call converts with the bit pattern.
                        BotConstructChatMessage(cs, m!.chatmessage!, UInt32(bitPattern: mcontext), bestmatch, UInt32(bitPattern: vcontext), 1)
                        BotRemoveTildes(&cs.chatmessageBuffer)
                        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
                        // Raven wrote: botimport.Print(PRT_MESSAGE, "%s\n", cs->chatmessage);
                        portMissing("BotReplyChat", source: "oracle/codemp/botlib/be_ai_chat.cpp:2597")
                        m = m!.next
                    }
                } else {
                    bestchatmessage!.time = AAS_Time() + CHATMESSAGE_RECENTTIME
                    // AI: Raven passes the `int` contexts to `unsigned long` parameters, and C converts them. The call converts with the bit pattern.
                    BotConstructChatMessage(cs, bestchatmessage!.chatmessage!, UInt32(bitPattern: mcontext), bestmatch, UInt32(bitPattern: vcontext), 1)
                }
                return 1
            }
            return 0
        }
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:2754
func BotChatLength(_ chatstate: Int32) -> Int32 {
    guard let cs = BotChatStateFromHandle(chatstate) else { return 0 }
    return strlen(cs.chatmessage)
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:2768
func BotEnterChat(_ chatstate: Int32, _ clientto: Int32, _ sendto: Int32) {
    guard let cs = BotChatStateFromHandle(chatstate) else { return }

    if strlen(cs.chatmessage) != 0 {
        BotRemoveTildes(&cs.chatmessageBuffer)
        if LibVarGetValue("bot_testichat") != 0 {
            // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
            // Raven wrote: botimport.Print(PRT_MESSAGE, "%s\n", cs->chatmessage);
            portMissing("BotEnterChat", source: "oracle/codemp/botlib/be_ai_chat.cpp:2768")
        } else {
            switch sendto {
            case CHAT_TEAM:
                var command = CharBuf(va("say_team %s", cs.chatmessage))
                EA_Command(cs.client, &command)
            case CHAT_TELL:
                var command = CharBuf(va("tell %d %s", clientto, cs.chatmessage))
                EA_Command(cs.client, &command)
            default: //CHAT_ALL
                var command = CharBuf(va("say %s", cs.chatmessage))
                EA_Command(cs.client, &command)
            }
        }
        //clear the chat message from the state
        strcpy(&cs.chatmessageBuffer, "")
    }
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:2804
func BotGetChatMessage(_ chatstate: Int32, _ buf: inout JKAShared.CharBuf, _ size: Int32) {
    guard let cs = BotChatStateFromHandle(chatstate) else { return }

    BotRemoveTildes(&cs.chatmessageBuffer)
    strncpy(&buf, cs.chatmessageBuffer, size - 1)
    buf[size - 1] = 0
    //clear the chat message from the state
    strcpy(&cs.chatmessageBuffer, "")
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:2823
func BotSetChatGender(_ chatstate: Int32, _ gender: Int32) {
    guard let cs = BotChatStateFromHandle(chatstate) else { return }
    switch gender {
    case CHAT_GENDERFEMALE: cs.gender = CHAT_GENDERFEMALE
    case CHAT_GENDERMALE: cs.gender = CHAT_GENDERMALE
    default: cs.gender = CHAT_GENDERLESS
    }
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:2842
func BotSetChatName(_ chatstate: Int32, _ name: String, _ client: Int32) {
    guard let cs = BotChatStateFromHandle(chatstate) else { return }
    cs.client = client
    cs.nameBuffer.zero()
    strncpy(&cs.nameBuffer, name, 32)
    cs.nameBuffer[32 - 1] = 0
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:2859
func BotResetChatAI() {
    var rchat: BotReplychat?
    var m: BotChatmessage?

    rchat = replychats
    while rchat != nil {
        m = rchat!.firstchatmessage
        while m != nil {
            m!.time = 0
            m = m!.next
        }
        rchat = rchat!.next
    }
}

//========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:2878
func BotAllocChatState() -> Int32 {
    var i: Int32

    i = 1
    while i <= MAX_CLIENTS {
        if botchatstates[i] == nil {
            botchatstates[i] = BotChatstate(GetClearedMemory(UInt32(BotChatstate.byteCount)))
            return i
        }
        i += 1
    }
    return 0
}

//========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:2898
func BotFreeChatState(_ handle: Int32) {
    if handle <= 0 || handle > MAX_CLIENTS {
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_FATAL, "chat state handle %d out of range\n", handle);
        portMissing("BotFreeChatState", source: "oracle/codemp/botlib/be_ai_chat.cpp:2898")
        return
    }
    if botchatstates[handle] == nil {
        // Port-note: The `char *fmt, ...` of `botlib_import_t.Print` has no text form in its view, row P1 of the bot-ai round.
        // Raven wrote: botimport.Print(PRT_FATAL, "invalid chat state %d\n", handle);
        portMissing("BotFreeChatState", source: "oracle/codemp/botlib/be_ai_chat.cpp:2898")
        return
    }
    if LibVarGetValue("bot_reloadcharacters") != 0 {
        BotFreeChatFile(handle)
    }
    //free all the console messages left in the chat state
    BotConsolemessage.scratch { m in
        var h: Int32

        h = BotNextConsoleMessage(handle, m)
        while h != 0 {
            //remove the console message
            BotRemoveConsoleMessage(handle, h)
            h = BotNextConsoleMessage(handle, m)
        }
    }
    FreeMemory(botchatstates[handle]!.handle)
    botchatstates[handle] = nil
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:2934
func BotSetupChatAI() -> Int32 {
    var file: CharBuf

    file = CharBuf(LibVarString("synfile", "syn.c"))
    synonyms = BotLoadSynonyms(&file)
    file = CharBuf(LibVarString("rndfile", "rnd.c"))
    randomstrings = BotLoadRandomStrings(&file)
    file = CharBuf(LibVarString("matchfile", "match.c"))
    matchtemplates = BotLoadMatchTemplates(&file)
    //
    if LibVarValue("nochat", "0") == 0 {
        file = CharBuf(LibVarString("rchatfile", "rchat.c"))
        replychats = BotLoadReplyChat(&file)
    }

    InitConsoleMessageHeap()

    return BLERR_NOERROR
}

//===========================================================================
//
// Parameter:				-
// Returns:					-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_chat.cpp:2968
func BotShutdownChatAI() {
    var i: Int32

    //free all remaining chat states
    i = 0
    while i < MAX_CLIENTS {
        if botchatstates[i] != nil {
            BotFreeChatState(i)
        }
        i += 1
    }
    //free all cached chats
    i = 0
    while i < MAX_CLIENTS {
        if ichatdata[i] != nil {
            FreeMemory(ichatdata[i]!.chat!.handle)
            FreeMemory(ichatdata[i]!.handle)
            ichatdata[i] = nil
        }
        i += 1
    }
    if consolemessageheap != nil { FreeMemory(consolemessageheap![0].handle) }
    consolemessageheap = nil
    if matchtemplates != nil { BotFreeMatchTemplates(matchtemplates!) }
    matchtemplates = nil
    if randomstrings != nil { FreeMemory(randomstrings!.handle) }
    randomstrings = nil
    if synonyms != nil { FreeMemory(synonyms!.handle) }
    synonyms = nil
    if replychats != nil { BotFreeReplyChat(replychats!) }
    replychats = nil
}
