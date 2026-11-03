import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/// Source: oracle/codemp/ui/ui_shared.c:19
let SCROLL_TIME_START = 500 as Int32

/// Source: oracle/codemp/ui/ui_shared.c:20
let SCROLL_TIME_ADJUST = 150 as Int32

/// Source: oracle/codemp/ui/ui_shared.c:21
let SCROLL_TIME_ADJUSTOFFSET = 40 as Int32

/// Source: oracle/codemp/ui/ui_shared.c:22
let SCROLL_TIME_FLOOR = 20 as Int32

/// Source: oracle/codemp/ui/ui_shared.c:97
// TODO: Port global scrollInfo
// Raven wrote: static scrollInfo_t scrollInfo
// No view for `struct scrollInfo_s`, a struct Raven defines inside a .c file.

/// Source: oracle/codemp/ui/ui_shared.c:99
// TODO: Port global captureFunc
// Raven wrote: static void (*captureFunc) (void *p) = 0
// No table row for `void (*)(void *)`.

/// Source: oracle/codemp/ui/ui_shared.c:100
var captureData: OpaquePointer? {
    get { world.variables.captureData }
    set { world.variables.captureData = newValue }
}

/// Source: oracle/codemp/ui/ui_shared.c:101
var itemCapture: ItemDef? {
    get { world.variables.itemCapture }
    set { world.variables.itemCapture = newValue }
}

/// Source: oracle/codemp/ui/ui_shared.c:103
var DC: DisplayContextDef? {
    get { world.variables.DC }
    set { world.variables.DC = newValue }
}

/// Source: oracle/codemp/ui/ui_shared.c:105
var g_waitingForKey: Bool {
    get { world.variables.g_waitingForKey }
    set { world.variables.g_waitingForKey = newValue }
}

/// Source: oracle/codemp/ui/ui_shared.c:106
var g_editingField: Bool {
    get { world.variables.g_editingField }
    set { world.variables.g_editingField = newValue }
}

/// Source: oracle/codemp/ui/ui_shared.c:108
var g_bindItem: ItemDef? {
    get { world.variables.g_bindItem }
    set { world.variables.g_bindItem = newValue }
}

/// Source: oracle/codemp/ui/ui_shared.c:109
var g_editItem: ItemDef? {
    get { world.variables.g_editItem }
    set { world.variables.g_editItem = newValue }
}

/// Source: oracle/codemp/ui/ui_shared.c:111
var Menus: Slots<MenuDef> { world.storage.Menus }

/// Source: oracle/codemp/ui/ui_shared.c:112
var menuCount: Int32 {
    get { world.variables.menuCount }
    set { world.variables.menuCount = newValue }
}

/// Source: oracle/codemp/ui/ui_shared.c:114
var menuStack: Slots<MenuDef?> { world.storage.menuStack }

/// Source: oracle/codemp/ui/ui_shared.c:115
var openMenuCount: Int32 {
    get { world.variables.openMenuCount }
    set { world.variables.openMenuCount = newValue }
}

/// Source: oracle/codemp/ui/ui_shared.c:117
var debugMode: Bool {
    get { world.variables.debugMode }
    set { world.variables.debugMode = newValue }
}

/// Source: oracle/codemp/ui/ui_shared.c:119
let DOUBLE_CLICK_DELAY = 300 as Int32

/// Source: oracle/codemp/ui/ui_shared.c:120
var lastListBoxClickTime: Int32 {
    get { world.variables.lastListBoxClickTime }
    set { world.variables.lastListBoxClickTime = newValue }
}

/// Source: oracle/codemp/ui/ui_shared.c:137
let MEM_POOL_SIZE = 128 * 1024 as Int32

/// Source: oracle/codemp/ui/ui_shared.c:138
// Raven wrote: #define UI_ALLOCATION_TAG TAG_CG_UI_ALLOC
// The macro's text is not a constant over this file's names, so a body spells its expansion at the site.

/// Source: oracle/codemp/ui/ui_shared.c:146
// Raven wrote: static char memoryPool[MEM_POOL_SIZE]
// No storage, by the HAND_VARS ruling.

/// Source: oracle/codemp/ui/ui_shared.c:149
var allocPoint: Int32 {
    get { world.variables.allocPoint }
    set { world.variables.allocPoint = newValue }
}

/// Source: oracle/codemp/ui/ui_shared.c:149
var outOfMemory: Int32 {
    get { world.variables.outOfMemory }
    set { world.variables.outOfMemory = newValue }
}

/// Source: oracle/codemp/ui/ui_shared.c:157
// TODO: Port global itemFlags
// Raven wrote: itemFlagsDef_t itemFlags []
// No view for `struct itemFlagsDef_s`, a struct Raven defines inside a .c file.

/// Source: oracle/codemp/ui/ui_shared.c:162
// Raven wrote: char *styles []
let styles: [String] = { () -> [String] in portMissing("styles", source: "oracle/codemp/ui/ui_shared.c:162") }()

/// Source: oracle/codemp/ui/ui_shared.c:172
// Raven wrote: char *alignment []
let alignment: [String] = { () -> [String] in portMissing("alignment", source: "oracle/codemp/ui/ui_shared.c:172") }()

/// Source: oracle/codemp/ui/ui_shared.c:179
// Raven wrote: char *types []
let types: [String] = { () -> [String] in portMissing("types", source: "oracle/codemp/ui/ui_shared.c:179") }()

/// Source: oracle/codemp/ui/ui_shared.c:257
let HASH_TABLE_SIZE = 2048 as Int32

/// Source: oracle/codemp/ui/ui_shared.c:284
var strPoolIndex: Int32 {
    get { world.variables.strPoolIndex }
    set { world.variables.strPoolIndex = newValue }
}

/// Source: oracle/codemp/ui/ui_shared.c:285
var strPool: JKAShared.CharBuf {
    get { world.variables.strPool }
    set { world.variables.strPool = newValue }
}

/// Source: oracle/codemp/ui/ui_shared.c:287
var strHandleCount: Int32 {
    get { world.variables.strHandleCount }
    set { world.variables.strHandleCount = newValue }
}

/// Source: oracle/codemp/ui/ui_shared.c:288
// TODO: Port global strHandle
// Raven wrote: static stringDef_t *strHandle[HASH_TABLE_SIZE]
// No table row for `stringDef_t *[2048]`.

/// Source: oracle/codemp/ui/ui_shared.c:1571
var FPMessageTime: Int32 {
    get { world.variables.FPMessageTime }
    set { world.variables.FPMessageTime = newValue }
}

/// Source: oracle/codemp/ui/ui_shared.c:1754
let MAX_DEFERRED_SCRIPT = 2048 as Int32

/// Source: oracle/codemp/ui/ui_shared.c:1756
var ui_deferredScript: JKAShared.CharBuf {
    get { world.variables.ui_deferredScript }
    set { world.variables.ui_deferredScript = newValue }
}

/// Source: oracle/codemp/ui/ui_shared.c:1757
var ui_deferredScriptItem: ItemDef? {
    get { world.variables.ui_deferredScriptItem }
    set { world.variables.ui_deferredScriptItem = newValue }
}

/// Source: oracle/codemp/ui/ui_shared.c:2196
// TODO: Port global commandList
// Raven wrote: commandDef_t commandList[]
// No view for `commandDef_t`, a struct Raven defines inside a .c file.

/// Source: oracle/codemp/ui/ui_shared.c:2304
// Raven wrote: int scriptCommandCount = sizeof(commandList) / sizeof(commandDef_t)
let scriptCommandCount: Int32 = { () -> Int32 in portMissing("scriptCommandCount", source: "oracle/codemp/ui/ui_shared.c:2304") }()

/// Source: oracle/codemp/ui/ui_shared.c:5190
// TODO: Port global g_bindings
// Raven wrote: static bind_t g_bindings[]
// No view for `bind_t`, a struct Raven defines inside a .c file.

/// Source: oracle/codemp/ui/ui_shared.c:5295
// Raven wrote: static const int g_bindCount = sizeof(g_bindings) / sizeof(bind_t)
let g_bindCount: Int32 = { () -> Int32 in portMissing("g_bindCount", source: "oracle/codemp/ui/ui_shared.c:5295") }()

/// Source: oracle/codemp/ui/ui_shared.c:5407
var g_nameBind1: JKAShared.CharBuf {
    get { world.variables.g_nameBind1 }
    set { world.variables.g_nameBind1 = newValue }
}

/// Source: oracle/codemp/ui/ui_shared.c:5408
var g_nameBind2: JKAShared.CharBuf {
    get { world.variables.g_nameBind2 }
    set { world.variables.g_nameBind2 = newValue }
}

/// Source: oracle/codemp/ui/ui_shared.c:5976
let COLOR_MAX = 255.0 as Float

/// Source: oracle/codemp/ui/ui_shared.c:7324
let KEYWORDHASH_SIZE = 512 as Int32

/// Source: oracle/codemp/ui/ui_shared.c:7487
// TODO: Port global ui_G2PtrTracker
// Raven wrote: uiG2PtrTracker_t *ui_G2PtrTracker = NULL
// No table row for `uiG2PtrTracker_t *`.

/// Source: oracle/codemp/ui/ui_shared.c:8601
// Raven wrote: char currLanguage[32][128]
nonisolated(unsafe) let currLanguage: [JKAShared.CharBuf] = [JKAShared.CharBuf](repeating: JKAShared.CharBuf(128), count: 32)

/// Source: oracle/codemp/ui/ui_shared.c:8602
// Raven wrote: static const char languageString[32] = "@MENUS_MYLANGUAGE"
nonisolated(unsafe) let languageString: JKAShared.CharBuf = { () -> JKAShared.CharBuf in portMissing("languageString", source: "oracle/codemp/ui/ui_shared.c:8602") }()

/// Source: oracle/codemp/ui/ui_shared.c:8892
// TODO: Port global itemParseKeywords
// Raven wrote: keywordHash_t itemParseKeywords[]
// No view for `struct keywordHash_s`, a struct Raven defines inside a .c file.

/// Source: oracle/codemp/ui/ui_shared.c:8988
// TODO: Port global itemParseKeywordHash
// Raven wrote: keywordHash_t *itemParseKeywordHash[KEYWORDHASH_SIZE]
// No table row for `keywordHash_t *[512]`.

/// Source: oracle/codemp/ui/ui_shared.c:9717
// TODO: Port global menuParseKeywords
// Raven wrote: keywordHash_t menuParseKeywords[]
// No view for `struct keywordHash_s`, a struct Raven defines inside a .c file.

/// Source: oracle/codemp/ui/ui_shared.c:9758
// TODO: Port global menuParseKeywordHash
// Raven wrote: keywordHash_t *menuParseKeywordHash[KEYWORDHASH_SIZE]
// No table row for `keywordHash_t *[512]`.

/**
```
===============
UI_Alloc
===============
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:209
func UI_Alloc(_ size: Int32) -> UnsafeMutableRawPointer {
    // TODO: Port UI_Alloc
    portMissing("UI_Alloc", source: "oracle/codemp/ui/ui_shared.c:209")
}

/**
```
===============
UI_InitMemory
===============
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:241
func UI_InitMemory() {
    allocPoint = 0
    outOfMemory = 0
}

/// Source: oracle/codemp/ui/ui_shared.c:249
func UI_OutOfMemory() -> Bool {
    return outOfMemory != 0
}

/**
```
================
return a hash value for the string
================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:263
private func hashForString(_ str: String) -> CLong {
    var i: Int32
    var hash: CLong
    var letter: CChar

    hash = 0
    i = 0
    while CharBuf(str)[i] != 0 {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot assign value of type 'Int32' to type 'CChar' (aka 'Int8')".
        // Raven wrote: letter = tolower((unsigned char)str[i])
        portMissing("hashForString", source: "oracle/codemp/ui/ui_shared.c:263")
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Int32' to expected argument type 'Int'".
        // Raven wrote: hash+=(long)(letter)*(i+119)
        portMissing("hashForString", source: "oracle/codemp/ui/ui_shared.c:263")
        i += 1
    }
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Int32' to expected argument type 'Int'".
    // Raven wrote: hash &= (HASH_TABLE_SIZE-1)
    portMissing("hashForString", source: "oracle/codemp/ui/ui_shared.c:263")
    return hash
}

/// Source: oracle/codemp/ui/ui_shared.c:291
func String_Alloc(_ p: String) -> String? {
    let len: Int32
    let hash: CLong
    // Port-note: A pointer local `stringDef_t * str` with no view.
    // Raven wrote: stringDef_t *str;
    portMissing("String_Alloc", source: "oracle/codemp/ui/ui_shared.c:291")
    // Port-note: A pointer local `stringDef_t * last` with no view.
    // Raven wrote: last;
    portMissing("String_Alloc", source: "oracle/codemp/ui/ui_shared.c:291")
    // Port-note: A static local `staticNULL` the function returns, storage that outlives the call.
    // Raven wrote: static const char *staticNULL = "";
    portMissing("String_Alloc", source: "oracle/codemp/ui/ui_shared.c:291")

    if p == nil {
        return nil
    }

    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: if (*p == 0) { return staticNULL; }
    portMissing("String_Alloc", source: "oracle/codemp/ui/ui_shared.c:291")

    hash = hashForString(p)

    // Port-note: A store into `str`, a local the draft left as a hole.
    // Raven wrote: str = strHandle[hash]
    portMissing("String_Alloc", source: "oracle/codemp/ui/ui_shared.c:291")
    // Port-note: A read of `str`, a local the draft left as a hole.
    // Raven wrote: while (str) { if (strcmp(p, str->str) == 0) { return str->str; } str = str->next; }
    portMissing("String_Alloc", source: "oracle/codemp/ui/ui_shared.c:291")

    len = strlen(p)
    if len + strPoolIndex + 1 < STRING_POOL_SIZE {
        let ph: Int32 = strPoolIndex
        strcpy(&strPool[strPoolIndex], p)
        strPoolIndex += len + 1

        // Port-note: A store into `str`, a local the draft left as a hole.
        // Raven wrote: str = strHandle[hash]
        portMissing("String_Alloc", source: "oracle/codemp/ui/ui_shared.c:291")
        // Port-note: A store into `last`, a local the draft left as a hole.
        // Raven wrote: last = str
        portMissing("String_Alloc", source: "oracle/codemp/ui/ui_shared.c:291")
        // Port-note: A read of `last`, a local the draft left as a hole.
        // Raven wrote: while (last && last->next) { last = last->next; }
        portMissing("String_Alloc", source: "oracle/codemp/ui/ui_shared.c:291")

        // Port-note: A store into `str`, a local the draft left as a hole.
        // Raven wrote: str = (stringDef_t *) UI_Alloc(sizeof(stringDef_t))
        portMissing("String_Alloc", source: "oracle/codemp/ui/ui_shared.c:291")
        // Port-note: A read of `str`, a local the draft left as a hole.
        // Raven wrote: str->next = NULL
        portMissing("String_Alloc", source: "oracle/codemp/ui/ui_shared.c:291")
        // Port-note: A read of `str`, a local the draft left as a hole.
        // Raven wrote: str->str = &strPool[ph]
        portMissing("String_Alloc", source: "oracle/codemp/ui/ui_shared.c:291")
        // Port-note: A read of `last`, a local the draft left as a hole.
        // Raven wrote: if (last) { last->next = str; } else { strHandle[hash] = str; }
        portMissing("String_Alloc", source: "oracle/codemp/ui/ui_shared.c:291")
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert return expression of type 'Int8' to return type 'String'".
        // Raven wrote: return &strPool[ph]
        portMissing("String_Alloc", source: "oracle/codemp/ui/ui_shared.c:291")
    }

    //Increase STRING_POOL_SIZE.
    return nil
}

/// Source: oracle/codemp/ui/ui_shared.c:344
func String_Report() {
    var f: Float
    Com_Printf("Memory/String Pool Info\n")
    Com_Printf("----------------\n")
    f = Float(strPoolIndex)
    f /= STRING_POOL_SIZE
    f *= 100
    Com_Printf("String Pool is %.1f%% full, %i bytes out of %i used.\n", f, strPoolIndex, STRING_POOL_SIZE)
    f = Float(allocPoint)
    f /= MEM_POOL_SIZE
    f *= 100
    Com_Printf("Memory Pool is %.1f%% full, %i bytes out of %i used.\n", f, allocPoint, MEM_POOL_SIZE)
}

/**
```
=================
String_Init
=================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:363
func String_Init() {
    var i: Int32
    i = 0
    while i < HASH_TABLE_SIZE {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'strHandle' in scope".
        // Raven wrote: strHandle[i] = 0
        portMissing("String_Init", source: "oracle/codemp/ui/ui_shared.c:363")
        i += 1
    }
    strHandleCount = 0
    strPoolIndex = 0
    menuCount = 0
    openMenuCount = 0
    UI_InitMemory()
    Item_SetupKeywordHash()
    Menu_SetupKeywordHash()
    if DC != nil && DC!.getBindingBuf != nil {
        Controls_GetConfig()
    }
}

/**
```
=================
PC_SourceWarning
=================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:385
func PC_SourceWarning(_ handle: Int32, _ format: inout JKAShared.CharBuf, _ args: any JKAShared.FormatArg...) {
    var line: Int32 = 0
    var filename = CharBuf(128)
    // Port-note: A pointer local `va_list argptr` with no view.
    // Raven wrote: va_list argptr;
    portMissing("PC_SourceWarning", source: "oracle/codemp/ui/ui_shared.c:385")
    var string = CharBuf(4096)

    // Port-note: A read of `argptr`, a local the draft left as a hole.
    // Raven wrote: va_start (argptr, format)
    portMissing("PC_SourceWarning", source: "oracle/codemp/ui/ui_shared.c:385")
    // Port-note: A read of `argptr`, a local the draft left as a hole.
    // Raven wrote: vsprintf (string, format, argptr)
    portMissing("PC_SourceWarning", source: "oracle/codemp/ui/ui_shared.c:385")
    // Port-note: A read of `argptr`, a local the draft left as a hole.
    // Raven wrote: va_end (argptr)
    portMissing("PC_SourceWarning", source: "oracle/codemp/ui/ui_shared.c:385")

    filename[0] = 0
    line = 0
    trap_PC_SourceFileAndLine(handle, String(filename), &line)

    Com_Printf(S_COLOR_YELLOW + "WARNING: %s, line %d: %s\n", filename, line, string)
}

/**
```
=================
PC_SourceError
=================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:407
func PC_SourceError(_ handle: Int32, _ format: inout JKAShared.CharBuf, _ args: any JKAShared.FormatArg...) {
    var line: Int32 = 0
    var filename = CharBuf(128)
    // Port-note: A pointer local `va_list argptr` with no view.
    // Raven wrote: va_list argptr;
    portMissing("PC_SourceError", source: "oracle/codemp/ui/ui_shared.c:407")
    var string = CharBuf(4096)

    // Port-note: A read of `argptr`, a local the draft left as a hole.
    // Raven wrote: va_start (argptr, format)
    portMissing("PC_SourceError", source: "oracle/codemp/ui/ui_shared.c:407")
    // Port-note: A read of `argptr`, a local the draft left as a hole.
    // Raven wrote: vsprintf (string, format, argptr)
    portMissing("PC_SourceError", source: "oracle/codemp/ui/ui_shared.c:407")
    // Port-note: A read of `argptr`, a local the draft left as a hole.
    // Raven wrote: va_end (argptr)
    portMissing("PC_SourceError", source: "oracle/codemp/ui/ui_shared.c:407")

    filename[0] = 0
    line = 0
    trap_PC_SourceFileAndLine(handle, String(filename), &line)

    Com_Printf(S_COLOR_RED + "ERROR: %s, line %d: %s\n", filename, line, string)
}

/**
```
=================
LerpColor
=================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:429
func LerpColor(_ a: JKAShared.vec4_t, _ b: JKAShared.vec4_t, _ c: inout JKAShared.vec4_t, _ t: Float) {
    var i: Int32

    // lerp and clamp each component
    i = 0
    while i < 4 {
        c[Int(i)] = a[Int(i)] + t * (b[Int(i)] - a[Int(i)])
        if c[Int(i)] < 0 {
            c[Int(i)] = 0
        } else if Double(c[Int(i)]) > 1.0 {
            c[Int(i)] = 1.0
        }
        i += 1
    }
}

/**
```
=================
Float_Parse
=================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:449
// TODO: Port signature
// Raven wrote: qboolean Float_Parse(char **p, float *f)
// No table row for `char ** p`.
func Float_Parse() -> Never {
    // TODO: Port Float_Parse
    portMissing("Float_Parse", source: "oracle/codemp/ui/ui_shared.c:449")
}

/**
```
=================
PC_Float_Parse
=================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:465
func PC_Float_Parse(_ handle: Int32, _ f: inout Float) -> Bool {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return PcToken.scratch { token -> Bool in
        var negative: Int32 = 0

        if trap_PC_ReadToken(handle, token) == 0 {
            return false
        }
        if token.stringBuffer[0] == Int32(ascii: "-") {
            if trap_PC_ReadToken(handle, token) == 0 {
                return false
            }
            negative = 1
        }
        if token.type != TT_NUMBER {
            // Port-note: Raven passes `"expected float but found %s\n"` to `PC_SourceError`, whose `char *` parameter the stub holds as an inout CharBuf. Docket row 5 is due.
            // Raven wrote: PC_SourceError(handle, "expected float but found %s\n", token.string)
            portMissing("PC_Float_Parse", source: "oracle/codemp/ui/ui_shared.c:465")
            return false
        }
        if negative != 0 {
            f = -token.floatvalue
        } else {
            f = token.floatvalue
        }
        return true
    }
}

/**
```
=================
Color_Parse
=================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:492
// TODO: Port signature
// Raven wrote: qboolean Color_Parse(char **p, vec4_t *c)
// No table row for `char ** p`.
func Color_Parse() -> Never {
    // TODO: Port Color_Parse
    portMissing("Color_Parse", source: "oracle/codemp/ui/ui_shared.c:492")
}

/**
```
=================
PC_Color_Parse
=================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:510
func PC_Color_Parse(_ handle: Int32, _ c: inout JKAShared.vec4_t) -> Bool {
    var i: Int32
    var f: Float = 0

    i = 0
    while i < 4 {
        if !PC_Float_Parse(handle, &f) {
            return false
        }
        (c)[Int(i)] = f
        i += 1
    }
    return true
}

/**
```
=================
Int_Parse
=================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:528
// TODO: Port signature
// Raven wrote: qboolean Int_Parse(char **p, int *i)
// No table row for `char ** p`.
func Int_Parse() -> Never {
    // TODO: Port Int_Parse
    portMissing("Int_Parse", source: "oracle/codemp/ui/ui_shared.c:528")
}

/**
```
=================
PC_Int_Parse
=================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:545
func PC_Int_Parse(_ handle: Int32, _ i: inout Int32) -> Bool {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return PcToken.scratch { token -> Bool in
        var negative: Int32 = 0

        if trap_PC_ReadToken(handle, token) == 0 {
            return false
        }
        if token.stringBuffer[0] == Int32(ascii: "-") {
            if trap_PC_ReadToken(handle, token) == 0 {
                return false
            }
            negative = 1
        }
        if token.type != TT_NUMBER {
            // Port-note: Raven passes `"expected integer but found %s\n"` to `PC_SourceError`, whose `char *` parameter the stub holds as an inout CharBuf. Docket row 5 is due.
            // Raven wrote: PC_SourceError(handle, "expected integer but found %s\n", token.string)
            portMissing("PC_Int_Parse", source: "oracle/codemp/ui/ui_shared.c:545")
            return false
        }
        i = token.intvalue
        if negative != 0 {
            i = -i
        }
        return true
    }
}

/**
```
=================
Rect_Parse
=================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:571
// TODO: Port signature
// Raven wrote: qboolean Rect_Parse(char **p, rectDef_t *r)
// No table row for `char ** p`.
func Rect_Parse() -> Never {
    // TODO: Port Rect_Parse
    portMissing("Rect_Parse", source: "oracle/codemp/ui/ui_shared.c:571")
}

/**
```
=================
PC_Rect_Parse
=================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:589
func PC_Rect_Parse(_ handle: Int32, _ r: JKAMP.RectDef) -> Bool {
    if PC_Float_Parse(handle, &r.x) {
        if PC_Float_Parse(handle, &r.y) {
            if PC_Float_Parse(handle, &r.w) {
                if PC_Float_Parse(handle, &r.h) {
                    return true
                }
            }
        }
    }
    return false
}

/**
```
=================
String_Parse
=================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:607
// TODO: Port signature
// Raven wrote: qboolean String_Parse(char **p, const char **out)
// No table row for `char ** p`.
func String_Parse() -> Never {
    // TODO: Port String_Parse
    portMissing("String_Parse", source: "oracle/codemp/ui/ui_shared.c:607")
}

/**
```
=================
PC_String_Parse
=================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:623
func PC_String_Parse(_ handle: Int32, _ out: inout String) -> Bool {
    let squiggy: String = "}"
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return PcToken.scratch { token -> Bool in

        if trap_PC_ReadToken(handle, token) == 0 {
            return false
        }

        // Save some memory by not return the end squiggy as an allocated string
        if Q_stricmp(token.string, "}") == 0 {
            // Port-note: A pointer dereference the draft cannot place.
            // Raven wrote: *(out) = squiggy
            portMissing("PC_String_Parse", source: "oracle/codemp/ui/ui_shared.c:623")
        } else {
            // Port-note: A pointer dereference the draft cannot place.
            // Raven wrote: *(out) = String_Alloc(token.string)
            portMissing("PC_String_Parse", source: "oracle/codemp/ui/ui_shared.c:623")
        }
        return true
    }
}

/**
```
=================
PC_Script_Parse
=================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:650
func PC_Script_Parse(_ handle: Int32, _ out: inout JKAShared.TextCursor) -> Bool {
    var script = CharBuf(2048)
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return PcToken.scratch { token -> Bool in

        script[0] = 0
        // scripts start with { and have ; separated command lists.. commands are command, arg..
        // basically we want everything between the { } as it will be interpreted at run time

        if trap_PC_ReadToken(handle, token) == 0 {
            return false
        }
        if Q_stricmp(token.string, "{") != 0 {
            return false
        }

        while 1 != 0 {
            if trap_PC_ReadToken(handle, token) == 0 {
                return false
            }

            if Q_stricmp(token.string, "}") == 0 {
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot assign value of type 'String?' to type 'TextCursor'".
                // Raven wrote: *out = String_Alloc(script)
                portMissing("PC_Script_Parse", source: "oracle/codemp/ui/ui_shared.c:650")
                return true
            }

            if token.stringBuffer[1] != 0 {
                Q_strcat(&script, 2048, va("\"%s\"", token.string))
            } else {
                Q_strcat(&script, 2048, token.string)
            }
            Q_strcat(&script, 2048, " ")
        }
        return false // bk001105 - LCC   missing return value
    }
}

/**
```
==================
Init_Display

Initializes the display with a structure to all the drawing routines
 ==================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:693
func Init_Display(_ dc: DisplayContextDef) {
    DC = dc
}

/// Source: oracle/codemp/ui/ui_shared.c:701
func GradientBar_Paint(_ rect: JKAMP.RectDef, _ color: JKAShared.vec4_t) {
    // gradient bar takes two paints
    DC!.runSetColor(color)
    DC!.runDrawHandlePic(rect.x, rect.y, rect.w, rect.h, DC!.Assets.gradientBar)
    // Port-note: NULL for `v`, a vec4_t parameter.
    // Raven wrote: DC->setColor( NULL )
    portMissing("GradientBar_Paint", source: "oracle/codemp/ui/ui_shared.c:701")
}

/**
```
==================
Window_Init

Initializes a window structure ( windowDef_t ) with defaults

==================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:717
func Window_Init(_ w: JKAMP.WindowDef) {
    w.clear()
    w.borderSize = 1
    w.foreColor[3] = 1.0
    w.foreColor[2] = w.foreColor[3]
    w.foreColor[1] = w.foreColor[2]
    w.foreColor[0] = w.foreColor[1]
    w.cinematic = -1
}

/// Source: oracle/codemp/ui/ui_shared.c:724
func Fade(_ flags: inout Int32, _ f: inout Float, _ clamp: Float, _ nextTime: inout Int32, _ offsetTime: Int32, _ bFlags: Bool, _ fadeAmount: Float) {
    if (flags & (WINDOW_FADINGOUT | WINDOW_FADINGIN)) != 0 {
        if DC!.realTime > nextTime {
            nextTime = DC!.realTime + offsetTime
            if (flags & WINDOW_FADINGOUT) != 0 {
                f -= fadeAmount
                if bFlags && f <= 0.0 {
                    flags &= ~(WINDOW_FADINGOUT | WINDOW_VISIBLE)
                }
            } else {
                f += fadeAmount
                if f >= clamp {
                    f = clamp
                    if bFlags {
                        flags &= ~WINDOW_FADINGIN
                    }
                }
            }
        }
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:748
func Window_Paint(_ w: JKAMP.WindowDef, _ fadeAmount: Float, _ fadeClamp: Float, _ fadeCycle: Float) {
    //float bordersize = 0;
    var color = vec4_t()
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = RectDef.scratch(copying: w.rect) { fillRect -> Bool in


        if debugMode {
            color[3] = 1
            color[2] = color[3]
            color[1] = color[2]
            color[0] = color[1]
            DC!.runDrawRect(w.rect.x, w.rect.y, w.rect.w, w.rect.h, 1, color)
        }

        if w == nil || (w.style == 0 && w.border == 0) {
            return true
        }

        if w.border != 0 {
            fillRect.x += w.borderSize
            fillRect.y += w.borderSize
            fillRect.w -= w.borderSize + 1
            fillRect.h -= w.borderSize + 1
        }

        if w.style == WINDOW_STYLE_FILLED {
            // box, but possible a shader that needs filled
            if w.background != 0 {
                Fade(&w.flags, &w.backColor[3], fadeClamp, &w.nextTime, Int32(fadeCycle), true, fadeAmount)
                DC!.runSetColor(vec4_t(w.backColor[0], w.backColor[1], w.backColor[2], w.backColor[3]))
                DC!.runDrawHandlePic(fillRect.x, fillRect.y, fillRect.w, fillRect.h, w.background)
                // Port-note: NULL for `v`, a vec4_t parameter.
                // Raven wrote: DC->setColor(NULL)
                portMissing("Window_Paint", source: "oracle/codemp/ui/ui_shared.c:748")
            } else {
                DC!.runFillRect(fillRect.x, fillRect.y, fillRect.w, fillRect.h, vec4_t(w.backColor[0], w.backColor[1], w.backColor[2], w.backColor[3]))
            }
        } else if w.style == WINDOW_STYLE_GRADIENT {
            GradientBar_Paint(fillRect, vec4_t(w.backColor[0], w.backColor[1], w.backColor[2], w.backColor[3]))
            // gradient bar
        } else if w.style == WINDOW_STYLE_SHADER {
            if (w.flags & WINDOW_FORECOLORSET) != 0 {
                DC!.runSetColor(vec4_t(w.foreColor[0], w.foreColor[1], w.foreColor[2], w.foreColor[3]))
            }
            DC!.runDrawHandlePic(fillRect.x, fillRect.y, fillRect.w, fillRect.h, w.background)
            // Port-note: NULL for `v`, a vec4_t parameter.
            // Raven wrote: DC->setColor(NULL)
            portMissing("Window_Paint", source: "oracle/codemp/ui/ui_shared.c:748")
        } else if w.style == WINDOW_STYLE_TEAMCOLOR {
            if DC!.getTeamColor != nil {
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'vec4_t' (aka 'SIMD4<Float>') to expected argument type 'OpaquePointer'".
                // Raven wrote: DC->getTeamColor(&color)
                portMissing("Window_Paint", source: "oracle/codemp/ui/ui_shared.c:748")
                DC!.runFillRect(fillRect.x, fillRect.y, fillRect.w, fillRect.h, color)
            }
        } else if w.style == WINDOW_STYLE_CINEMATIC {
            if w.cinematic == -1 {
                w.cinematic = DC!.runPlayCinematic(w.cinematicName!, fillRect.x, fillRect.y, fillRect.w, fillRect.h)
                if w.cinematic == -1 {
                    w.cinematic = -2
                }
            }
            if w.cinematic >= 0 {
                DC!.runRunCinematicFrame(w.cinematic)
                DC!.runDrawCinematic(w.cinematic, fillRect.x, fillRect.y, fillRect.w, fillRect.h)
            }
        }

        if w.border == WINDOW_BORDER_FULL {
            // full
            // HACK HACK HACK
            if w.style == WINDOW_STYLE_TEAMCOLOR {
                if color[0] > 0 {
                    // red
                    color[0] = 1
                    color[2] = 0.5
                    color[1] = color[2]
                } else {
                    color[2] = 1
                    color[1] = 0.5
                    color[0] = color[1]
                }
                color[3] = 1
                DC!.runDrawRect(w.rect.x, w.rect.y, w.rect.w, w.rect.h, w.borderSize, color)
            } else {
                DC!.runDrawRect(w.rect.x, w.rect.y, w.rect.w, w.rect.h, w.borderSize, vec4_t(w.borderColor[0], w.borderColor[1], w.borderColor[2], w.borderColor[3]))
            }
        } else if w.border == WINDOW_BORDER_HORZ {
            // top/bottom
            DC!.runSetColor(vec4_t(w.borderColor[0], w.borderColor[1], w.borderColor[2], w.borderColor[3]))
            DC!.runDrawTopBottom(w.rect.x, w.rect.y, w.rect.w, w.rect.h, w.borderSize)
            // Port-note: NULL for `v`, a vec4_t parameter.
            // Raven wrote: DC->setColor( NULL )
            portMissing("Window_Paint", source: "oracle/codemp/ui/ui_shared.c:748")
        } else if w.border == WINDOW_BORDER_VERT {
            // left right
            DC!.runSetColor(vec4_t(w.borderColor[0], w.borderColor[1], w.borderColor[2], w.borderColor[3]))
            DC!.runDrawSides(w.rect.x, w.rect.y, w.rect.w, w.rect.h, w.borderSize)
            // Port-note: NULL for `v`, a vec4_t parameter.
            // Raven wrote: DC->setColor( NULL )
            portMissing("Window_Paint", source: "oracle/codemp/ui/ui_shared.c:748")
        } else if w.border == WINDOW_BORDER_KCGRADIENT {
            // this is just two gradient bars along each horz edge
            // Raven's record lives to the end of his block, so the block is the closure.
            RectDef.scratch(copying: w.rect) { r in
                r.h = w.borderSize
                GradientBar_Paint(r, vec4_t(w.borderColor[0], w.borderColor[1], w.borderColor[2], w.borderColor[3]))
                r.y = w.rect.y + w.rect.h - 1
                GradientBar_Paint(r, vec4_t(w.borderColor[0], w.borderColor[1], w.borderColor[2], w.borderColor[3]))
            }
        }
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:891
func Item_SetScreenCoords(_ item: ItemDef, _ x: Float, _ y: Float) {
    // Raven assigns his own `x` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var x = x
    // Raven assigns his own `y` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var y = y

    if item == nil {
        return
    }

    if item.window.border != 0 {
        x += item.window.borderSize
        y += item.window.borderSize
    }

    item.window.rect.x = x + item.window.rectClient.x
    item.window.rect.y = y + item.window.rectClient.y
    item.window.rect.w = item.window.rectClient.w
    item.window.rect.h = item.window.rectClient.h

    // force the text rects to recompute
    item.textRect.w = 0
    item.textRect.h = 0

    switch item.type {
    case ITEM_TYPE_TEXTSCROLL:
        do {
            // Port-note: A pointer local `textScrollDef_t * scrollPtr` with no view.
            // Raven wrote: textScrollDef_t *scrollPtr = (textScrollDef_t*)item->typeData;
            portMissing("Item_SetScreenCoords", source: "oracle/codemp/ui/ui_shared.c:891")
            // Port-note: A read of `scrollPtr`, a local the draft left as a hole.
            // Raven wrote: if ( scrollPtr ) { scrollPtr->startPos = 0; scrollPtr->endPos = 0; }
            portMissing("Item_SetScreenCoords", source: "oracle/codemp/ui/ui_shared.c:891")

            Item_TextScroll_BuildLines(item)

            break
        }

    default:
        break
    }
}

// FIXME: consolidate this with nearby stuff
/// Source: oracle/codemp/ui/ui_shared.c:933
func Item_UpdatePosition(_ item: ItemDef) {
    var x: Float
    var y: Float
    var menu: MenuDef?

    if item == nil || item.parent == nil {
        return
    }

    // Port-note: The draft of this statement did not compile, and the compiler wrote "missing argument label 'handle:' in call".
    // Raven wrote: menu = (menuDef_t *) item->parent
    portMissing("Item_UpdatePosition", source: "oracle/codemp/ui/ui_shared.c:933")

    x = menu!.window.rect.x
    y = menu!.window.rect.y

    if menu!.window.border != 0 {
        x += menu!.window.borderSize
        y += menu!.window.borderSize
    }

    Item_SetScreenCoords(item, x, y)
}

// menus
/// Source: oracle/codemp/ui/ui_shared.c:959
func Menu_UpdatePosition(_ menu: MenuDef) {
    var i: Int32
    var x: Float
    var y: Float

    if menu == nil {
        return
    }

    x = menu.window.rect.x
    y = menu.window.rect.y
    if menu.window.border != 0 {
        x += menu.window.borderSize
        y += menu.window.borderSize
    }

    i = 0
    while i < menu.itemCount {
        Item_SetScreenCoords(menu.items[i]!, x, y)
        i += 1
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:979
func Menu_PostParse(_ menu: MenuDef) {
    if menu == nil {
        return
    }
    if menu.fullScreen {
        menu.window.rect.x = 0
        menu.window.rect.y = 0
        menu.window.rect.w = 640
        menu.window.rect.h = 480
    }
    Menu_UpdatePosition(menu)
}

/// Source: oracle/codemp/ui/ui_shared.c:992
func Menu_ClearFocus(_ menu: MenuDef) -> ItemDef? {
    var i: Int32
    var ret: ItemDef? = nil

    if menu == nil {
        return nil
    }

    i = 0
    while i < menu.itemCount {
        if (menu.items[i]!.window.flags & WINDOW_HASFOCUS) != 0 {
            ret = menu.items[i]
        }
        menu.items[i]!.window.flags &= ~WINDOW_HASFOCUS
        if menu.items[i]!.leaveFocus != nil {
            Item_RunScript(menu.items[i]!, menu.items[i]!.leaveFocus!)
        }
        i += 1
    }

    return ret
}

/// Source: oracle/codemp/ui/ui_shared.c:1013
func IsVisible(_ flags: Int32) -> Bool {
    return ((flags & WINDOW_VISIBLE) != 0 && !((flags & WINDOW_FADINGOUT) != 0))
}

/// Source: oracle/codemp/ui/ui_shared.c:1017
func Rect_ContainsPoint(_ rect: JKAMP.RectDef, _ x: Float, _ y: Float) -> Bool {
    if x > rect.x && x < rect.x + rect.w && y > rect.y && y < rect.y + rect.h {
        return true
    }
    return false
}

/// Source: oracle/codemp/ui/ui_shared.c:1026
func Menu_ItemsMatchingGroup(_ menu: MenuDef, _ name: String) -> Int32 {
    var i: Int32
    var count: Int32 = 0

    i = 0
    while i < menu.itemCount {
        if (menu.items[i]!.window.name == nil) && (menu.items[i]!.window.group == nil) {
            Com_Printf(S_COLOR_YELLOW + "WARNING: item has neither name or group\n")
            i += 1
            continue
        }

        if Q_stricmp(menu.items[i]!.window.name!, name) == 0 || (menu.items[i]!.window.group != nil && Q_stricmp(menu.items[i]!.window.group!, name) == 0) {
            count += 1
        }
        i += 1
    }

    return count
}

/// Source: oracle/codemp/ui/ui_shared.c:1049
func Menu_GetMatchingItemByNumber(_ menu: MenuDef, _ index: Int32, _ name: String) -> ItemDef? {
    var i: Int32
    var count: Int32 = 0
    i = 0
    while i < menu.itemCount {
        if Q_stricmp(menu.items[i]!.window.name!, name) == 0 || (menu.items[i]!.window.group != nil && Q_stricmp(menu.items[i]!.window.group!, name) == 0) {
            if count == index {
                return menu.items[i]
            }
            count += 1
        }
        i += 1
    }
    return nil
}

/// Source: oracle/codemp/ui/ui_shared.c:1063
// TODO: Port signature
// Raven wrote: qboolean Script_SetColor ( itemDef_t *item, char **args )
// No table row for `char ** args`.
func Script_SetColor() -> Never {
    // TODO: Port Script_SetColor
    portMissing("Script_SetColor", source: "oracle/codemp/ui/ui_shared.c:1063")
}

/// Source: oracle/codemp/ui/ui_shared.c:1105
// TODO: Port signature
// Raven wrote: qboolean Script_SetAsset(itemDef_t *item, char **args)
// No table row for `char ** args`.
func Script_SetAsset() -> Never {
    // TODO: Port Script_SetAsset
    portMissing("Script_SetAsset", source: "oracle/codemp/ui/ui_shared.c:1105")
}

/// Source: oracle/codemp/ui/ui_shared.c:1119
// TODO: Port signature
// Raven wrote: qboolean Script_SetBackground(itemDef_t *item, char **args)
// No table row for `char ** args`.
func Script_SetBackground() -> Never {
    // TODO: Port Script_SetBackground
    portMissing("Script_SetBackground", source: "oracle/codemp/ui/ui_shared.c:1119")
}

/// Source: oracle/codemp/ui/ui_shared.c:1130
// TODO: Port signature
// Raven wrote: qboolean Script_SetItemRectCvar(itemDef_t *item, char **args)
// No table row for `char ** args`.
func Script_SetItemRectCvar() -> Never {
    // TODO: Port Script_SetItemRectCvar
    portMissing("Script_SetItemRectCvar", source: "oracle/codemp/ui/ui_shared.c:1130")
}

/// Source: oracle/codemp/ui/ui_shared.c:1193
// TODO: Port signature
// Raven wrote: qboolean Script_SetItemBackground(itemDef_t *item, char **args)
// No table row for `char ** args`.
func Script_SetItemBackground() -> Never {
    // TODO: Port Script_SetItemBackground
    portMissing("Script_SetItemBackground", source: "oracle/codemp/ui/ui_shared.c:1193")
}

/// Source: oracle/codemp/ui/ui_shared.c:1206
// TODO: Port signature
// Raven wrote: qboolean Script_SetItemText(itemDef_t *item, char **args)
// No table row for `char ** args`.
func Script_SetItemText() -> Never {
    // TODO: Port Script_SetItemText
    portMissing("Script_SetItemText", source: "oracle/codemp/ui/ui_shared.c:1206")
}

/// Source: oracle/codemp/ui/ui_shared.c:1220
func Menu_FindItemByName(_ menu: MenuDef, _ p: String) -> ItemDef? {
    var i: Int32
    if menu == nil || p == nil {
        return nil
    }

    i = 0
    while i < menu.itemCount {
        if Q_stricmp(p, menu.items[i]!.window.name!) == 0 {
            return menu.items[i]
        }
        i += 1
    }

    return nil
}

/// Source: oracle/codemp/ui/ui_shared.c:1235
// TODO: Port signature
// Raven wrote: qboolean Script_SetTeamColor(itemDef_t *item, char **args)
// No table row for `char ** args`.
func Script_SetTeamColor() -> Never {
    // TODO: Port Script_SetTeamColor
    portMissing("Script_SetTeamColor", source: "oracle/codemp/ui/ui_shared.c:1235")
}

/// Source: oracle/codemp/ui/ui_shared.c:1250
// TODO: Port signature
// Raven wrote: qboolean Script_SetItemColor(itemDef_t *item, char **args)
// No table row for `char ** args`.
func Script_SetItemColor() -> Never {
    // TODO: Port Script_SetItemColor
    portMissing("Script_SetItemColor", source: "oracle/codemp/ui/ui_shared.c:1250")
}

/// Source: oracle/codemp/ui/ui_shared.c:1314
// TODO: Port signature
// Raven wrote: qboolean Script_SetItemColorCvar(itemDef_t *item, char **args)
// No table row for `char ** args`.
func Script_SetItemColorCvar() -> Never {
    // TODO: Port Script_SetItemColorCvar
    portMissing("Script_SetItemColorCvar", source: "oracle/codemp/ui/ui_shared.c:1314")
}

/// Source: oracle/codemp/ui/ui_shared.c:1403
// TODO: Port signature
// Raven wrote: qboolean Script_SetItemRect(itemDef_t *item, char **args)
// No table row for `char ** args`.
func Script_SetItemRect() -> Never {
    // TODO: Port Script_SetItemRect
    portMissing("Script_SetItemRect", source: "oracle/codemp/ui/ui_shared.c:1403")
}

/// Source: oracle/codemp/ui/ui_shared.c:1444
func Menu_ShowGroup(_ menu: MenuDef, _ groupName: String, _ showFlag: Bool) {
    var item: ItemDef?
    let count: Int32
    var j: Int32

    count = Menu_ItemsMatchingGroup(menu, groupName)
    j = 0
    while j < count {
        item = Menu_GetMatchingItemByNumber(menu, j, groupName)
        if item != nil {
            if showFlag {
                item!.window.flags |= WINDOW_VISIBLE
            } else {
                item!.window.flags &= ~(WINDOW_VISIBLE | WINDOW_HASFOCUS)
            }
        }
        j += 1
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:1467
func Menu_ShowItemByName(_ menu: MenuDef, _ p: String, _ bShow: Bool) {
    var item: ItemDef?
    var i: Int32
    let count: Int32 = Menu_ItemsMatchingGroup(menu, p)
    i = 0
    while i < count {
        item = Menu_GetMatchingItemByNumber(menu, i, p)
        if item != nil {
            if bShow {
                item!.window.flags |= WINDOW_VISIBLE
            } else {
                item!.window.flags &= ~WINDOW_VISIBLE
                // stop cinematics playing in the window
                if item!.window.cinematic >= 0 {
                    DC!.runStopCinematic(item!.window.cinematic)
                    item!.window.cinematic = -1
                }
            }
        }
        i += 1
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:1488
func Menu_FadeItemByName(_ menu: MenuDef, _ p: String, _ fadeOut: Bool) {
    var item: ItemDef?
    var i: Int32
    let count: Int32 = Menu_ItemsMatchingGroup(menu, p)
    i = 0
    while i < count {
        item = Menu_GetMatchingItemByNumber(menu, i, p)
        if item != nil {
            if fadeOut {
                item!.window.flags |= (WINDOW_FADINGOUT | WINDOW_VISIBLE)
                item!.window.flags &= ~WINDOW_FADINGIN
            } else {
                item!.window.flags |= (WINDOW_VISIBLE | WINDOW_FADINGIN)
                item!.window.flags &= ~WINDOW_FADINGOUT
            }
        }
        i += 1
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:1506
func Menus_FindByName(_ p: String) -> MenuDef? {
    var i: Int32
    i = 0
    while i < menuCount {
        if Q_stricmp(Menus[i].window.name!, p) == 0 {
            return Menus[i]
        }
        i += 1
    }
    return nil
}

/// Source: oracle/codemp/ui/ui_shared.c:1516
func Menus_ShowByName(_ p: String) {
    let menu: MenuDef? = Menus_FindByName(p)
    if menu != nil {
        Menus_Activate(menu!)
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:1523
func Menus_OpenByName(_ p: String) {
    Menus_ActivateByName(p)
}

/// Source: oracle/codemp/ui/ui_shared.c:1527
private func Menu_RunCloseScript(_ menu: MenuDef) {
    if (menu.window.flags & WINDOW_VISIBLE) != 0 && menu.onClose != nil {
        // Raven's record lives to the end of his block, so the block is the closure.
        ItemDef.scratch { item in
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot assign value of type 'MenuDef' to type 'OpaquePointer'".
            // Raven wrote: item.parent = menu
            portMissing("Menu_RunCloseScript", source: "oracle/codemp/ui/ui_shared.c:1527")
            Item_RunScript(item, menu.onClose!)
        }
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:1535
func Menus_CloseByName(_ p: String) {
    let menu: MenuDef? = Menus_FindByName(p)

    // If the menu wasnt found just exit
    if menu == nil {
        return
    }

    // Run the close script for the menu
    Menu_RunCloseScript(menu!)

    // If this window had the focus then take it away
    if (menu!.window.flags & WINDOW_HASFOCUS) != 0 {
        // If there is something still in the open menu list then
        // set it to have focus now
        if openMenuCount != 0 {
            // Subtract one from the open menu count to prepare to
            // remove the top menu from the list
            openMenuCount -= 1

            // Set the top menu to have focus now
            menuStack[openMenuCount]!.window.flags |= WINDOW_HASFOCUS

            // Remove the top menu from the list
            menuStack[openMenuCount] = nil
        }
    }

    // Window is now invisible and doenst have focus
    menu!.window.flags &= ~(WINDOW_VISIBLE | WINDOW_HASFOCUS)
}

/// Source: oracle/codemp/ui/ui_shared.c:1573
func Menus_CloseAll() {
    var i: Int32

    g_waitingForKey = false

    i = 0
    while i < menuCount {
        Menu_RunCloseScript(Menus[i])
        Menus[i].window.flags &= ~(WINDOW_HASFOCUS | WINDOW_VISIBLE)
        i += 1
    }

    // Clear the menu stack
    openMenuCount = 0

    FPMessageTime = 0
}

/// Source: oracle/codemp/ui/ui_shared.c:1591
// TODO: Port signature
// Raven wrote: qboolean Script_Show(itemDef_t *item, char **args)
// No table row for `char ** args`.
func Script_Show() -> Never {
    // TODO: Port Script_Show
    portMissing("Script_Show", source: "oracle/codemp/ui/ui_shared.c:1591")
}

/// Source: oracle/codemp/ui/ui_shared.c:1601
// TODO: Port signature
// Raven wrote: qboolean Script_Hide(itemDef_t *item, char **args)
// No table row for `char ** args`.
func Script_Hide() -> Never {
    // TODO: Port Script_Hide
    portMissing("Script_Hide", source: "oracle/codemp/ui/ui_shared.c:1601")
}

/// Source: oracle/codemp/ui/ui_shared.c:1611
// TODO: Port signature
// Raven wrote: qboolean Script_FadeIn(itemDef_t *item, char **args)
// No table row for `char ** args`.
func Script_FadeIn() -> Never {
    // TODO: Port Script_FadeIn
    portMissing("Script_FadeIn", source: "oracle/codemp/ui/ui_shared.c:1611")
}

/// Source: oracle/codemp/ui/ui_shared.c:1622
// TODO: Port signature
// Raven wrote: qboolean Script_FadeOut(itemDef_t *item, char **args)
// No table row for `char ** args`.
func Script_FadeOut() -> Never {
    // TODO: Port Script_FadeOut
    portMissing("Script_FadeOut", source: "oracle/codemp/ui/ui_shared.c:1622")
}

/// Source: oracle/codemp/ui/ui_shared.c:1632
// TODO: Port signature
// Raven wrote: qboolean Script_Open(itemDef_t *item, char **args)
// No table row for `char ** args`.
func Script_Open() -> Never {
    // TODO: Port Script_Open
    portMissing("Script_Open", source: "oracle/codemp/ui/ui_shared.c:1632")
}

/// Source: oracle/codemp/ui/ui_shared.c:1642
// TODO: Port signature
// Raven wrote: qboolean Script_Close(itemDef_t *item, char **args)
// No table row for `char ** args`.
func Script_Close() -> Never {
    // TODO: Port Script_Close
    portMissing("Script_Close", source: "oracle/codemp/ui/ui_shared.c:1642")
}

//void Menu_TransitionItemByName(menuDef_t *menu, const char *p, rectDef_t rectFrom, rectDef_t rectTo, int time, float amt)
/// Source: oracle/codemp/ui/ui_shared.c:1660
func Menu_TransitionItemByName(_ menu: MenuDef, _ p: String, _ rectFrom: JKAMP.RectDef?, _ rectTo: JKAMP.RectDef, _ time: Int32, _ amt: Float) {
    var item: ItemDef?
    var i: Int32
    let count: Int32 = Menu_ItemsMatchingGroup(menu, p)
    // Raven assigns his own `rectFrom` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var rectFrom = rectFrom
    i = 0
    while i < count {
        item = Menu_GetMatchingItemByNumber(menu, i, p)
        if item != nil {
            if rectFrom == nil {
                rectFrom = item!.window.rect //if there are more than one of these with the same name, they'll all use the FIRST one's FROM.
            }
            item!.window.flags |= (WINDOW_INTRANSITION | WINDOW_VISIBLE)
            item!.window.offsetTime = time
            // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'RectDef?' must be unwrapped to a value of type 'RectDef'".
            // Raven wrote: memcpy(&item->window.rectClient, rectFrom, sizeof(rectDef_t))
            portMissing("Menu_TransitionItemByName", source: "oracle/codemp/ui/ui_shared.c:1660")
            item!.window.rectEffects.copy(from: rectTo)
            item!.window.rectEffects2.x = abs(rectTo.x - rectFrom!.x) / amt
            item!.window.rectEffects2.y = abs(rectTo.y - rectFrom!.y) / amt
            item!.window.rectEffects2.w = abs(rectTo.w - rectFrom!.w) / amt
            item!.window.rectEffects2.h = abs(rectTo.h - rectFrom!.h) / amt

            Item_UpdatePosition(item!)
        }
        i += 1
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:1696
func Menu_Transition3ItemByName(_ menu: MenuDef, _ p: String, _ minx: Float, _ miny: Float, _ minz: Float, _ maxx: Float, _ maxy: Float, _ maxz: Float, _ fovtx: Float, _ fovty: Float, _ time: Int32, _ amt: Float) {
    var item: ItemDef?
    var i: Int32
    let count: Int32 = Menu_ItemsMatchingGroup(menu, p)
    // Port-note: A pointer local `modelDef_t * modelptr` with no view.
    // Raven wrote: modelDef_t * modelptr;
    portMissing("Menu_Transition3ItemByName", source: "oracle/codemp/ui/ui_shared.c:1696")
    i = 0
    while i < count {
        item = Menu_GetMatchingItemByNumber(menu, i, p)
        if item != nil {
            if item!.type == ITEM_TYPE_MODEL {
                // Port-note: A store into `modelptr`, a local the draft left as a hole.
                // Raven wrote: modelptr = (modelDef_t*)item->typeData
                portMissing("Menu_Transition3ItemByName", source: "oracle/codemp/ui/ui_shared.c:1696")

                item!.window.flags |= (WINDOW_INTRANSITIONMODEL | WINDOW_VISIBLE)
                item!.window.offsetTime = time
                // Port-note: A read of `modelptr`, a local the draft left as a hole.
                // Raven wrote: modelptr->fov_x2 = fovtx
                portMissing("Menu_Transition3ItemByName", source: "oracle/codemp/ui/ui_shared.c:1696")
                // Port-note: A read of `modelptr`, a local the draft left as a hole.
                // Raven wrote: modelptr->fov_y2 = fovty
                portMissing("Menu_Transition3ItemByName", source: "oracle/codemp/ui/ui_shared.c:1696")
                // Port-note: A read of `modelptr`, a local the draft left as a hole.
                // Raven wrote: VectorSet(modelptr->g2maxs2, maxx, maxy, maxz)
                portMissing("Menu_Transition3ItemByName", source: "oracle/codemp/ui/ui_shared.c:1696")
                // Port-note: A read of `modelptr`, a local the draft left as a hole.
                // Raven wrote: VectorSet(modelptr->g2mins2, minx, miny, minz)
                portMissing("Menu_Transition3ItemByName", source: "oracle/codemp/ui/ui_shared.c:1696")

                //				//modelptr->g2maxs2.x= maxx;
                //				modelptr->g2maxs2.y= maxy;
                //				modelptr->g2maxs2.z= maxz;
                //				modelptr->g2mins2.x= minx;
                //				modelptr->g2mins2.y= miny;
                //				modelptr->g2mins2.z= minz;

                //				VectorSet(modelptr->g2maxs2, maxx, maxy, maxz);

                // Port-note: A read of `modelptr`, a local the draft left as a hole.
                // Raven wrote: modelptr->g2maxsEffect[0] = abs(modelptr->g2maxs2[0] - modelptr->g2maxs[0]) / amt
                portMissing("Menu_Transition3ItemByName", source: "oracle/codemp/ui/ui_shared.c:1696")
                // Port-note: A read of `modelptr`, a local the draft left as a hole.
                // Raven wrote: modelptr->g2maxsEffect[1] = abs(modelptr->g2maxs2[1] - modelptr->g2maxs[1]) / amt
                portMissing("Menu_Transition3ItemByName", source: "oracle/codemp/ui/ui_shared.c:1696")
                // Port-note: A read of `modelptr`, a local the draft left as a hole.
                // Raven wrote: modelptr->g2maxsEffect[2] = abs(modelptr->g2maxs2[2] - modelptr->g2maxs[2]) / amt
                portMissing("Menu_Transition3ItemByName", source: "oracle/codemp/ui/ui_shared.c:1696")

                // Port-note: A read of `modelptr`, a local the draft left as a hole.
                // Raven wrote: modelptr->g2minsEffect[0] = abs(modelptr->g2mins2[0] - modelptr->g2mins[0]) / amt
                portMissing("Menu_Transition3ItemByName", source: "oracle/codemp/ui/ui_shared.c:1696")
                // Port-note: A read of `modelptr`, a local the draft left as a hole.
                // Raven wrote: modelptr->g2minsEffect[1] = abs(modelptr->g2mins2[1] - modelptr->g2mins[1]) / amt
                portMissing("Menu_Transition3ItemByName", source: "oracle/codemp/ui/ui_shared.c:1696")
                // Port-note: A read of `modelptr`, a local the draft left as a hole.
                // Raven wrote: modelptr->g2minsEffect[2] = abs(modelptr->g2mins2[2] - modelptr->g2mins[2]) / amt
                portMissing("Menu_Transition3ItemByName", source: "oracle/codemp/ui/ui_shared.c:1696")


                // Port-note: A read of `modelptr`, a local the draft left as a hole.
                // Raven wrote: modelptr->fov_Effectx = abs(modelptr->fov_x2 - modelptr->fov_x) / amt
                portMissing("Menu_Transition3ItemByName", source: "oracle/codemp/ui/ui_shared.c:1696")
                // Port-note: A read of `modelptr`, a local the draft left as a hole.
                // Raven wrote: modelptr->fov_Effecty = abs(modelptr->fov_y2 - modelptr->fov_y) / amt
                portMissing("Menu_Transition3ItemByName", source: "oracle/codemp/ui/ui_shared.c:1696")
            }
        }
        i += 1
    }
}

/**
```
=================
Script_Defer

Defers the rest of the script based on the defer condition.  The deferred
portion of the script can later be run with the "rundeferred"
=================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:1767
// TODO: Port signature
// Raven wrote: qboolean Script_Defer ( itemDef_t* item, char **args )
// No table row for `char ** args`.
func Script_Defer() -> Never {
    // TODO: Port Script_Defer
    portMissing("Script_Defer", source: "oracle/codemp/ui/ui_shared.c:1767")
}

/**
```
=================
Script_RunDeferred

Runs the last deferred script, there can only be one script deferred at a
time so be careful of recursion
=================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:1794
// TODO: Port signature
// Raven wrote: qboolean Script_RunDeferred ( itemDef_t* item, char **args )
// No table row for `char ** args`.
func Script_RunDeferred() -> Never {
    // TODO: Port Script_RunDeferred
    portMissing("Script_RunDeferred", source: "oracle/codemp/ui/ui_shared.c:1794")
}

/// Source: oracle/codemp/ui/ui_shared.c:1808
// TODO: Port signature
// Raven wrote: qboolean Script_Transition(itemDef_t *item, char **args)
// No table row for `char ** args`.
func Script_Transition() -> Never {
    // TODO: Port Script_Transition
    portMissing("Script_Transition", source: "oracle/codemp/ui/ui_shared.c:1808")
}

/// Source: oracle/codemp/ui/ui_shared.c:1826
func Menu_OrbitItemByName(_ menu: MenuDef, _ p: String, _ x: Float, _ y: Float, _ cx: Float, _ cy: Float, _ time: Int32) {
    var item: ItemDef?
    var i: Int32
    let count: Int32 = Menu_ItemsMatchingGroup(menu, p)
    i = 0
    while i < count {
        item = Menu_GetMatchingItemByNumber(menu, i, p)
        if item != nil {
            item!.window.flags |= (WINDOW_ORBITING | WINDOW_VISIBLE)
            item!.window.offsetTime = time
            item!.window.rectEffects.x = cx
            item!.window.rectEffects.y = cy
            item!.window.rectClient.x = x
            item!.window.rectClient.y = y
            Item_UpdatePosition(item!)
        }
        i += 1
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:1845
func Menu_ItemDisable(_ menu: MenuDef, _ name: String, _ disableFlag: Int32) {
    var j: Int32
    let count: Int32
    var itemFound: ItemDef?

    count = Menu_ItemsMatchingGroup(menu, name)
    // Loop through all items that have this name
    j = 0
    while j < count {
        itemFound = Menu_GetMatchingItemByNumber(menu, j, name)
        if itemFound != nil {
            itemFound!.disabled = disableFlag != 0
            // Just in case it had focus
            itemFound!.window.flags &= ~WINDOW_MOUSEOVER
        }
        j += 1
    }
}

// Set item disable flags
/// Source: oracle/codemp/ui/ui_shared.c:1865
// TODO: Port signature
// Raven wrote: qboolean Script_Disable(itemDef_t *item, char **args)
// No table row for `char ** args`.
func Script_Disable() -> Never {
    // TODO: Port Script_Disable
    portMissing("Script_Disable", source: "oracle/codemp/ui/ui_shared.c:1865")
}

// Scale the given item instantly.
/// Source: oracle/codemp/ui/ui_shared.c:1895
// TODO: Port signature
// Raven wrote: qboolean Script_Scale(itemDef_t *item, char **args)
// No table row for `char ** args`.
func Script_Scale() -> Never {
    // TODO: Port Script_Scale
    portMissing("Script_Scale", source: "oracle/codemp/ui/ui_shared.c:1895")
}

/// Source: oracle/codemp/ui/ui_shared.c:1939
// TODO: Port signature
// Raven wrote: qboolean Script_Orbit(itemDef_t *item, char **args)
// No table row for `char ** args`.
func Script_Orbit() -> Never {
    // TODO: Port Script_Orbit
    portMissing("Script_Orbit", source: "oracle/codemp/ui/ui_shared.c:1939")
}

/// Source: oracle/codemp/ui/ui_shared.c:1956
// TODO: Port signature
// Raven wrote: qboolean Script_SetFocus(itemDef_t *item, char **args)
// No table row for `char ** args`.
func Script_SetFocus() -> Never {
    // TODO: Port Script_SetFocus
    portMissing("Script_SetFocus", source: "oracle/codemp/ui/ui_shared.c:1956")
}

/// Source: oracle/codemp/ui/ui_shared.c:1986
// TODO: Port signature
// Raven wrote: qboolean Script_SetPlayerModel(itemDef_t *item, char **args)
// No table row for `char ** args`.
func Script_SetPlayerModel() -> Never {
    // TODO: Port Script_SetPlayerModel
    portMissing("Script_SetPlayerModel", source: "oracle/codemp/ui/ui_shared.c:1986")
}

/**
```
=================
ParseRect
=================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:2002
func ParseRect(_ p: inout JKAShared.TextCursor, _ r: JKAMP.RectDef) -> Bool {
    if !COM_ParseFloat(&p, &r.x) {
        if !COM_ParseFloat(&p, &r.y) {
            if !COM_ParseFloat(&p, &r.w) {
                if !COM_ParseFloat(&p, &r.h) {
                    return true
                }
            }
        }
    }
    return false
}

/**
```
=================
Script_Transition2
uses current origin instead of specifing a starting origin

transition2		lfvscr		25 0 202 264  20 25
=================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:2027
// TODO: Port signature
// Raven wrote: qboolean Script_Transition2(itemDef_t *item, char **args)
// No table row for `char ** args`.
func Script_Transition2() -> Never {
    // TODO: Port Script_Transition2
    portMissing("Script_Transition2", source: "oracle/codemp/ui/ui_shared.c:2027")
}

/**
```
JLF
=================
Script_Transition3

used exclusively with model views
uses current origin instead of specifing a starting origin


transition3		lfvscr		(min extent) (max extent) (fovx,y)  20 25
=================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:2062
// TODO: Port signature
// Raven wrote: qboolean Script_Transition3(itemDef_t *item, char **args)
// No table row for `char ** args`.
func Script_Transition3() -> Never {
    // TODO: Port Script_Transition3
    portMissing("Script_Transition3", source: "oracle/codemp/ui/ui_shared.c:2062")
}

/// Source: oracle/codemp/ui/ui_shared.c:2150
// TODO: Port signature
// Raven wrote: qboolean Script_SetCvar(itemDef_t *item, char **args)
// No table row for `char ** args`.
func Script_SetCvar() -> Never {
    // TODO: Port Script_SetCvar
    portMissing("Script_SetCvar", source: "oracle/codemp/ui/ui_shared.c:2150")
}

/// Source: oracle/codemp/ui/ui_shared.c:2160
// TODO: Port signature
// Raven wrote: qboolean Script_SetCvarToCvar(itemDef_t *item, char **args)
// No table row for `char ** args`.
func Script_SetCvarToCvar() -> Never {
    // TODO: Port Script_SetCvarToCvar
    portMissing("Script_SetCvarToCvar", source: "oracle/codemp/ui/ui_shared.c:2160")
}

/// Source: oracle/codemp/ui/ui_shared.c:2170
// TODO: Port signature
// Raven wrote: qboolean Script_Exec(itemDef_t *item, char **args)
// No table row for `char ** args`.
func Script_Exec() -> Never {
    // TODO: Port Script_Exec
    portMissing("Script_Exec", source: "oracle/codemp/ui/ui_shared.c:2170")
}

/// Source: oracle/codemp/ui/ui_shared.c:2178
// TODO: Port signature
// Raven wrote: qboolean Script_Play(itemDef_t *item, char **args)
// No table row for `char ** args`.
func Script_Play() -> Never {
    // TODO: Port Script_Play
    portMissing("Script_Play", source: "oracle/codemp/ui/ui_shared.c:2178")
}

/// Source: oracle/codemp/ui/ui_shared.c:2186
// TODO: Port signature
// Raven wrote: qboolean Script_playLooped(itemDef_t *item, char **args)
// No table row for `char ** args`.
func Script_playLooped() -> Never {
    // TODO: Port Script_playLooped
    portMissing("Script_playLooped", source: "oracle/codemp/ui/ui_shared.c:2186")
}

// Set all the items within a given menu, with the given itemName, to the given shader
/// Source: oracle/codemp/ui/ui_shared.c:2231
func Menu_SetItemBackground(_ menu: MenuDef, _ itemName: String, _ background: String) {
    var item: ItemDef?
    var j: Int32
    let count: Int32


    count = Menu_ItemsMatchingGroup(menu, itemName)

    j = 0
    while j < count {
        item = Menu_GetMatchingItemByNumber(menu, j, itemName)
        if item != nil {
            item!.window.background = DC!.runRegisterShaderNoMip(background)
        }
        j += 1
    }
}

// Set all the items within a given menu, with the given itemName, to the given text
/// Source: oracle/codemp/ui/ui_shared.c:2254
func Menu_SetItemText(_ menu: MenuDef, _ itemName: String, _ text: String) {
    var item: ItemDef?
    var j: Int32
    let count: Int32


    count = Menu_ItemsMatchingGroup(menu, itemName)

    j = 0
    while j < count {
        item = Menu_GetMatchingItemByNumber(menu, j, itemName)
        if item != nil {
            if CharBuf(text)[0] == Int32(ascii: "*") {
                item!.text = nil // Null this out because this would take presidence over cvar text.
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Int' to expected argument type 'String'".
                // Raven wrote: item->cvar = text+1
                portMissing("Menu_SetItemText", source: "oracle/codemp/ui/ui_shared.c:2254")
                // Just copying what was in ItemParse_cvar()
                if item!.typeData != nil {
                    // Port-note: A pointer local `editFieldDef_t * editPtr` with no view.
                    // Raven wrote: editFieldDef_t *editPtr;
                    portMissing("Menu_SetItemText", source: "oracle/codemp/ui/ui_shared.c:2254")
                    // Port-note: A store into `editPtr`, a local the draft left as a hole.
                    // Raven wrote: editPtr = (editFieldDef_t*)item->typeData
                    portMissing("Menu_SetItemText", source: "oracle/codemp/ui/ui_shared.c:2254")
                    // Port-note: A read of `editPtr`, a local the draft left as a hole.
                    // Raven wrote: editPtr->minVal = -1
                    portMissing("Menu_SetItemText", source: "oracle/codemp/ui/ui_shared.c:2254")
                    // Port-note: A read of `editPtr`, a local the draft left as a hole.
                    // Raven wrote: editPtr->maxVal = -1
                    portMissing("Menu_SetItemText", source: "oracle/codemp/ui/ui_shared.c:2254")
                    // Port-note: A read of `editPtr`, a local the draft left as a hole.
                    // Raven wrote: editPtr->defVal = -1
                    portMissing("Menu_SetItemText", source: "oracle/codemp/ui/ui_shared.c:2254")
                }
            } else {
                item!.text = text
                if item!.type == ITEM_TYPE_TEXTSCROLL {
                    // Port-note: A pointer local `textScrollDef_t * scrollPtr` with no view.
                    // Raven wrote: textScrollDef_t *scrollPtr = (textScrollDef_t*)item->typeData;
                    portMissing("Menu_SetItemText", source: "oracle/codemp/ui/ui_shared.c:2254")
                    // Port-note: A read of `scrollPtr`, a local the draft left as a hole.
                    // Raven wrote: if ( scrollPtr ) { scrollPtr->startPos = 0; scrollPtr->endPos = 0; }
                    portMissing("Menu_SetItemText", source: "oracle/codemp/ui/ui_shared.c:2254")

                    Item_TextScroll_BuildLines(item!)
                }
            }
        }
        j += 1
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:2306
func Item_RunScript(_ item: ItemDef, _ s: String) {
    var script = CharBuf(2048)
    var p = TextCursor()
    var i: Int32
    var bRan: Bool

    script[0] = 0

    if !s.isEmpty {
        Q_strcat(&script, 2048, s)
        p = TextCursor(script)

        while 1 != 0 {
            // Port-note: A pointer local `const char * command` with no view.
            // Raven wrote: const char *command;
            portMissing("Item_RunScript", source: "oracle/codemp/ui/ui_shared.c:2306")

            // expect command then arguments, ; ends command, NULL ends script
            // Port-note: A read of `command`, a local the draft left as a hole.
            // Raven wrote: if (!String_Parse(&p, &command)) { return; }
            portMissing("Item_RunScript", source: "oracle/codemp/ui/ui_shared.c:2306")

            // Port-note: A read of `command`, a local the draft left as a hole.
            // Raven wrote: if (command[0] == ';' && command[1] == '\0') { continue; }
            portMissing("Item_RunScript", source: "oracle/codemp/ui/ui_shared.c:2306")

            bRan = false
            i = 0
            while i < scriptCommandCount {
                // Port-note: A read of `command`, a local the draft left as a hole.
                // Raven wrote: if (Q_stricmp(command, commandList[i].name) == 0) { // Allow a script command to stop processing the script if ( !commandList[i].handler(item, &p) ) { return; } bRan = qtrue; break; }
                portMissing("Item_RunScript", source: "oracle/codemp/ui/ui_shared.c:2306")
                i += 1
            }

            // not in our auto list, pass to handler
            if !bRan {
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'TextCursor' to expected argument type 'OpaquePointer'".
                // Raven wrote: DC->runScript(&p)
                portMissing("Item_RunScript", source: "oracle/codemp/ui/ui_shared.c:2306")
            }
        }
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:2360
func Item_EnableShowViaCvar(_ item: ItemDef, _ flag: Int32) -> Bool {
    var script = CharBuf(2048)
    var p = TextCursor()
    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: if (item && item->enableCvar && *item->enableCvar && item->cvarTest && *item->cvarTest) { char buff[2048]; DC->getCVarString(item->cvarTest, buff, sizeof(buff)); Q_strncpyz(script, item->enableCvar, 2048); p = script; while (1) { const char *val; // expect value then ; or NULL, NULL ends list if (!String_Parse(&p, &val)) { return (item->cvarFlags & flag) ? qfalse : qtrue; } if (val[0] == ';' && val[1] == '\0') { continue; } // enable it if any of the values are true if (item->cvarFlags & flag) { if (Q_stricmp(buff, val) == 0) { return qtrue; } } else { // disable it if any of the values are true if (Q_stricmp(buff, val) == 0) { return qfalse; } } } return (item->cvarFlags & flag) ? qfalse : qtrue; }
    portMissing("Item_EnableShowViaCvar", source: "oracle/codemp/ui/ui_shared.c:2360")
    return true
}

// will optionaly set focus to this item
/// Source: oracle/codemp/ui/ui_shared.c:2399
func Item_SetFocus(_ item: ItemDef, _ x: Float, _ y: Float) -> Bool {
    var i: Int32 = 0
    var oldFocus: ItemDef?
    // Port-note: A pointer local `sfxHandle_t * sfx` with no view.
    // Raven wrote: sfxHandle_t *sfx = &DC->Assets.itemFocusSound;
    portMissing("Item_SetFocus", source: "oracle/codemp/ui/ui_shared.c:2399")
    var playSound: Bool = false
    var parent: MenuDef?
    // sanity check, non-null, not a decoration and does not already have the focus
    if item == nil || (item.window.flags & WINDOW_DECORATION) != 0 || (item.window.flags & WINDOW_HASFOCUS) != 0 || !((item.window.flags & WINDOW_VISIBLE) != 0) {
        return false
    }

    // bk001206 - this can be NULL.
    // Port-note: The draft of this statement did not compile, and the compiler wrote "missing argument label 'handle:' in call".
    // Raven wrote: parent = (menuDef_t*)item->parent
    portMissing("Item_SetFocus", source: "oracle/codemp/ui/ui_shared.c:2399")

    // items can be enabled and disabled
    if item.disabled {
        return false
    }

    // items can be enabled and disabled based on cvars
    if (item.cvarFlags & (CVAR_ENABLE | CVAR_DISABLE)) != 0 && !Item_EnableShowViaCvar(item, CVAR_ENABLE) {
        return false
    }

    if (item.cvarFlags & (CVAR_SHOW | CVAR_HIDE)) != 0 && !Item_EnableShowViaCvar(item, CVAR_SHOW) {
        return false
    }

    // Port-note: The draft of this statement did not compile, and the compiler wrote "missing argument label 'handle:' in call".
    // Raven wrote: oldFocus = Menu_ClearFocus((menuDef_t *) item->parent)
    portMissing("Item_SetFocus", source: "oracle/codemp/ui/ui_shared.c:2399")

    if item.type == ITEM_TYPE_TEXT {
        // Raven's record lives to the end of his block, so the block is the closure.
        RectDef.scratch(copying: item.textRect) { r in
            r.y -= r.h

            //JLFMOUSE
            if Rect_ContainsPoint(r, x, y) {
                item.window.flags |= WINDOW_HASFOCUS
                if item.focusSound != 0 {
                    // Port-note: A store into `sfx`, a local the draft left as a hole.
                    // Raven wrote: sfx = &item->focusSound
                    portMissing("Item_SetFocus", source: "oracle/codemp/ui/ui_shared.c:2399")
                }
                playSound = true
            } else {
                if oldFocus != nil {
                    oldFocus!.window.flags |= WINDOW_HASFOCUS
                    if oldFocus!.onFocus != nil {
                        Item_RunScript(oldFocus!, oldFocus!.onFocus!)
                    }
                }
            }
        }
    } else {
        item.window.flags |= WINDOW_HASFOCUS
        if item.onFocus != nil {
            Item_RunScript(item, item.onFocus!)
        }
        if item.focusSound != 0 {
            // Port-note: A store into `sfx`, a local the draft left as a hole.
            // Raven wrote: sfx = &item->focusSound
            portMissing("Item_SetFocus", source: "oracle/codemp/ui/ui_shared.c:2399")
        }
        playSound = true
    }

    // Port-note: A read of `sfx`, a local the draft left as a hole.
    // Raven wrote: if (playSound && sfx) { DC->startLocalSound( *sfx, CHAN_LOCAL_SOUND ); }
    portMissing("Item_SetFocus", source: "oracle/codemp/ui/ui_shared.c:2399")

    i = 0
    while i < parent!.itemCount {
        if parent!.items[i] == item {
            parent!.cursorItem = i
            break
        }
        i += 1
    }

    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:2482
func Item_TextScroll_MaxScroll(_ item: ItemDef) -> Int32 {
    // Port-note: A pointer local `textScrollDef_t * scrollPtr` with no view.
    // Raven wrote: textScrollDef_t *scrollPtr = (textScrollDef_t*)item->typeData;
    portMissing("Item_TextScroll_MaxScroll", source: "oracle/codemp/ui/ui_shared.c:2482")

    // Port-note: A read of `scrollPtr`, a local the draft left as a hole.
    // Raven wrote: int count = scrollPtr->iLineCount;
    portMissing("Item_TextScroll_MaxScroll", source: "oracle/codemp/ui/ui_shared.c:2482")
    // Port-note: A read of `count`, a local the draft left as a hole.
    // Raven wrote: int max = count - (int)(item->window.rect.h / scrollPtr->lineHeight) + 1;
    portMissing("Item_TextScroll_MaxScroll", source: "oracle/codemp/ui/ui_shared.c:2482")

    // Port-note: A read of `max`, a local the draft left as a hole.
    // Raven wrote: if (max < 0) { return 0; }
    portMissing("Item_TextScroll_MaxScroll", source: "oracle/codemp/ui/ui_shared.c:2482")

    // Port-note: A read of `max`, a local the draft left as a hole.
    // Raven wrote: return max
    portMissing("Item_TextScroll_MaxScroll", source: "oracle/codemp/ui/ui_shared.c:2482")
}

/// Source: oracle/codemp/ui/ui_shared.c:2497
func Item_TextScroll_ThumbPosition(_ item: ItemDef) -> Int32 {
    let max: Float
    var pos: Float
    let size: Float
    // Port-note: A pointer local `textScrollDef_t * scrollPtr` with no view.
    // Raven wrote: textScrollDef_t *scrollPtr = (textScrollDef_t*)item->typeData;
    portMissing("Item_TextScroll_ThumbPosition", source: "oracle/codemp/ui/ui_shared.c:2497")

    max = Float(Item_TextScroll_MaxScroll(item))
    size = Float(Double(item.window.rect.h) - (SCROLLBAR_SIZE * 2) - 2)

    if max > 0 {
        pos = Float((Double(size) - SCROLLBAR_SIZE) / Double(Float(max)))
    } else {
        pos = 0
    }

    // Port-note: A read of `scrollPtr`, a local the draft left as a hole.
    // Raven wrote: pos *= scrollPtr->startPos
    portMissing("Item_TextScroll_ThumbPosition", source: "oracle/codemp/ui/ui_shared.c:2497")

    return Int32(Double(item.window.rect.y + 1) + SCROLLBAR_SIZE + Double(pos))
}

/// Source: oracle/codemp/ui/ui_shared.c:2519
func Item_TextScroll_ThumbDrawPosition(_ item: ItemDef) -> Int32 {
    let min: Int32
    let max: Int32

    if itemCapture == item {
        min = Int32(Double(item.window.rect.y) + SCROLLBAR_SIZE + 1)
        max = Int32(Double(item.window.rect.y + item.window.rect.h) - 2 * SCROLLBAR_SIZE - 1)

        if Double(DC!.cursory) >= Double(min) + SCROLLBAR_SIZE / 2 && Double(DC!.cursory) <= Double(max) + SCROLLBAR_SIZE / 2 {
            return Int32(Double(DC!.cursory) - SCROLLBAR_SIZE / 2)
        }

        return Item_TextScroll_ThumbPosition(item)
    }

    return Item_TextScroll_ThumbPosition(item)
}

/// Source: oracle/codemp/ui/ui_shared.c:2539
func Item_TextScroll_OverLB(_ item: ItemDef, _ x: Float, _ y: Float) -> Int32 {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return RectDef.scratch { r -> Int32 in
        // Port-note: A pointer local `textScrollDef_t * scrollPtr` with no view.
        // Raven wrote: textScrollDef_t *scrollPtr;
        portMissing("Item_TextScroll_OverLB", source: "oracle/codemp/ui/ui_shared.c:2539")
        var thumbstart: Int32 = 0
        var count: Int32 = 0

        // Port-note: A store into `scrollPtr`, a local the draft left as a hole.
        // Raven wrote: scrollPtr = (textScrollDef_t*)item->typeData
        portMissing("Item_TextScroll_OverLB", source: "oracle/codemp/ui/ui_shared.c:2539")
        // Port-note: A read of `scrollPtr`, a local the draft left as a hole.
        // Raven wrote: count = scrollPtr->iLineCount
        portMissing("Item_TextScroll_OverLB", source: "oracle/codemp/ui/ui_shared.c:2539")

        r.x = Float(Double(item.window.rect.x + item.window.rect.w) - SCROLLBAR_SIZE)
        r.y = item.window.rect.y
        r.w = Float(SCROLLBAR_SIZE)
        r.h = r.w
        if Rect_ContainsPoint(r, x, y) {
            return WINDOW_LB_LEFTARROW
        }

        r.y = Float(Double(item.window.rect.y + item.window.rect.h) - SCROLLBAR_SIZE)
        if Rect_ContainsPoint(r, x, y) {
            return WINDOW_LB_RIGHTARROW
        }

        thumbstart = Item_TextScroll_ThumbPosition(item)
        r.y = Float(thumbstart)
        if Rect_ContainsPoint(r, x, y) {
            return WINDOW_LB_THUMB
        }

        r.y = Float(Double(item.window.rect.y) + SCROLLBAR_SIZE)
        r.h = thumbstart - r.y
        if Rect_ContainsPoint(r, x, y) {
            return WINDOW_LB_PGUP
        }

        r.y = Float(Double(thumbstart) + SCROLLBAR_SIZE)
        r.h = Float(Double(item.window.rect.y + item.window.rect.h) - SCROLLBAR_SIZE)
        if Rect_ContainsPoint(r, x, y) {
            return WINDOW_LB_PGDN
        }

        return 0
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:2587
func Item_TextScroll_MouseEnter(_ item: ItemDef, _ x: Float, _ y: Float) {
    item.window.flags &= ~(WINDOW_LB_LEFTARROW | WINDOW_LB_RIGHTARROW | WINDOW_LB_THUMB | WINDOW_LB_PGUP | WINDOW_LB_PGDN)
    item.window.flags |= Item_TextScroll_OverLB(item, x, y)
}

/// Source: oracle/codemp/ui/ui_shared.c:2593
func Item_TextScroll_HandleKey(_ item: ItemDef, _ key: Int32, _ down: Bool, _ force: Bool) -> Bool {
    // Port-note: A pointer local `textScrollDef_t * scrollPtr` with no view.
    // Raven wrote: textScrollDef_t *scrollPtr = (textScrollDef_t*)item->typeData;
    portMissing("Item_TextScroll_HandleKey", source: "oracle/codemp/ui/ui_shared.c:2593")
    let max: Int32
    let viewmax: Int32

    if force || (Rect_ContainsPoint(item.window.rect, Float(DC!.cursorx), Float(DC!.cursory)) && (item.window.flags & WINDOW_HASFOCUS) != 0) {
        max = Item_TextScroll_MaxScroll(item)

        // Port-note: A read of `scrollPtr`, a local the draft left as a hole.
        // Raven wrote: viewmax = (item->window.rect.h / scrollPtr->lineHeight)
        portMissing("Item_TextScroll_HandleKey", source: "oracle/codemp/ui/ui_shared.c:2593")
        if key == A_CURSOR_UP || key == A_KP_8 {
            // Port-note: A read of `scrollPtr`, a local the draft left as a hole.
            // Raven wrote: scrollPtr->startPos--
            portMissing("Item_TextScroll_HandleKey", source: "oracle/codemp/ui/ui_shared.c:2593")
            // Port-note: A read of `scrollPtr`, a local the draft left as a hole.
            // Raven wrote: if (scrollPtr->startPos < 0) { scrollPtr->startPos = 0; }
            portMissing("Item_TextScroll_HandleKey", source: "oracle/codemp/ui/ui_shared.c:2593")
            return true
        }

        if key == A_CURSOR_DOWN || key == A_KP_2 {
            // Port-note: A read of `scrollPtr`, a local the draft left as a hole.
            // Raven wrote: scrollPtr->startPos++
            portMissing("Item_TextScroll_HandleKey", source: "oracle/codemp/ui/ui_shared.c:2593")
            // Port-note: A read of `scrollPtr`, a local the draft left as a hole.
            // Raven wrote: if (scrollPtr->startPos > max) { scrollPtr->startPos = max; }
            portMissing("Item_TextScroll_HandleKey", source: "oracle/codemp/ui/ui_shared.c:2593")

            return true
        }

        // mouse hit
        if key == A_MOUSE1 || key == A_MOUSE2 {
            if (item.window.flags & WINDOW_LB_LEFTARROW) != 0 {
                // Port-note: A read of `scrollPtr`, a local the draft left as a hole.
                // Raven wrote: scrollPtr->startPos--
                portMissing("Item_TextScroll_HandleKey", source: "oracle/codemp/ui/ui_shared.c:2593")
                // Port-note: A read of `scrollPtr`, a local the draft left as a hole.
                // Raven wrote: if (scrollPtr->startPos < 0) { scrollPtr->startPos = 0; }
                portMissing("Item_TextScroll_HandleKey", source: "oracle/codemp/ui/ui_shared.c:2593")
            } else if (item.window.flags & WINDOW_LB_RIGHTARROW) != 0 {
                // one down
                // Port-note: A read of `scrollPtr`, a local the draft left as a hole.
                // Raven wrote: scrollPtr->startPos++
                portMissing("Item_TextScroll_HandleKey", source: "oracle/codemp/ui/ui_shared.c:2593")
                // Port-note: A read of `scrollPtr`, a local the draft left as a hole.
                // Raven wrote: if (scrollPtr->startPos > max) { scrollPtr->startPos = max; }
                portMissing("Item_TextScroll_HandleKey", source: "oracle/codemp/ui/ui_shared.c:2593")
            } else if (item.window.flags & WINDOW_LB_PGUP) != 0 {
                // page up
                // Port-note: A read of `scrollPtr`, a local the draft left as a hole.
                // Raven wrote: scrollPtr->startPos -= viewmax
                portMissing("Item_TextScroll_HandleKey", source: "oracle/codemp/ui/ui_shared.c:2593")
                // Port-note: A read of `scrollPtr`, a local the draft left as a hole.
                // Raven wrote: if (scrollPtr->startPos < 0) { scrollPtr->startPos = 0; }
                portMissing("Item_TextScroll_HandleKey", source: "oracle/codemp/ui/ui_shared.c:2593")
            } else if (item.window.flags & WINDOW_LB_PGDN) != 0 {
                // page down
                // Port-note: A read of `scrollPtr`, a local the draft left as a hole.
                // Raven wrote: scrollPtr->startPos += viewmax
                portMissing("Item_TextScroll_HandleKey", source: "oracle/codemp/ui/ui_shared.c:2593")
                // Port-note: A read of `scrollPtr`, a local the draft left as a hole.
                // Raven wrote: if (scrollPtr->startPos > max) { scrollPtr->startPos = max; }
                portMissing("Item_TextScroll_HandleKey", source: "oracle/codemp/ui/ui_shared.c:2593")
            } else if (item.window.flags & WINDOW_LB_THUMB) != 0 {
                // Display_SetCaptureItem(item);
            }

            return true
        }

        if key == A_HOME || key == A_KP_7 {
            // home
            // Port-note: A read of `scrollPtr`, a local the draft left as a hole.
            // Raven wrote: scrollPtr->startPos = 0
            portMissing("Item_TextScroll_HandleKey", source: "oracle/codemp/ui/ui_shared.c:2593")
            return true
        }
        if key == A_END || key == A_KP_1 {
            // end
            // Port-note: A read of `scrollPtr`, a local the draft left as a hole.
            // Raven wrote: scrollPtr->startPos = max
            portMissing("Item_TextScroll_HandleKey", source: "oracle/codemp/ui/ui_shared.c:2593")
            return true
        }
        if key == A_PAGE_UP || key == A_KP_9 {
            // Port-note: A read of `scrollPtr`, a local the draft left as a hole.
            // Raven wrote: scrollPtr->startPos -= viewmax
            portMissing("Item_TextScroll_HandleKey", source: "oracle/codemp/ui/ui_shared.c:2593")
            // Port-note: A read of `scrollPtr`, a local the draft left as a hole.
            // Raven wrote: if (scrollPtr->startPos < 0) { scrollPtr->startPos = 0; }
            portMissing("Item_TextScroll_HandleKey", source: "oracle/codemp/ui/ui_shared.c:2593")

            return true
        }
        if key == A_PAGE_DOWN || key == A_KP_3 {
            // Port-note: A read of `scrollPtr`, a local the draft left as a hole.
            // Raven wrote: scrollPtr->startPos += viewmax
            portMissing("Item_TextScroll_HandleKey", source: "oracle/codemp/ui/ui_shared.c:2593")
            // Port-note: A read of `scrollPtr`, a local the draft left as a hole.
            // Raven wrote: if (scrollPtr->startPos > max) { scrollPtr->startPos = max; }
            portMissing("Item_TextScroll_HandleKey", source: "oracle/codemp/ui/ui_shared.c:2593")
            return true
        }
    }

    return false
}

/// Source: oracle/codemp/ui/ui_shared.c:2707
func Item_ListBox_MaxScroll(_ item: ItemDef) -> Int32 {
    // Port-note: A pointer local `listBoxDef_t * listPtr` with no view.
    // Raven wrote: listBoxDef_t *listPtr = (listBoxDef_t*)item->typeData;
    portMissing("Item_ListBox_MaxScroll", source: "oracle/codemp/ui/ui_shared.c:2707")
    let count: Int32 = DC!.runFeederCount(item.special)
    let max: Int32

    if (item.window.flags & WINDOW_HORIZONTAL) != 0 {
        // Port-note: A read of `listPtr`, a local the draft left as a hole.
        // Raven wrote: max = count - (item->window.rect.w / listPtr->elementWidth) + 1
        portMissing("Item_ListBox_MaxScroll", source: "oracle/codemp/ui/ui_shared.c:2707")
    } else {
        // Port-note: A read of `listPtr`, a local the draft left as a hole.
        // Raven wrote: max = count - (item->window.rect.h / listPtr->elementHeight) + 1
        portMissing("Item_ListBox_MaxScroll", source: "oracle/codemp/ui/ui_shared.c:2707")
    }
    if max < 0 {
        return 0
    }
    return max
}

/// Source: oracle/codemp/ui/ui_shared.c:2724
func Item_ListBox_ThumbPosition(_ item: ItemDef) -> Int32 {
    let max: Float
    var pos: Float
    let size: Float
    // Port-note: A pointer local `listBoxDef_t * listPtr` with no view.
    // Raven wrote: listBoxDef_t *listPtr = (listBoxDef_t*)item->typeData;
    portMissing("Item_ListBox_ThumbPosition", source: "oracle/codemp/ui/ui_shared.c:2724")

    max = Float(Item_ListBox_MaxScroll(item))
    if (item.window.flags & WINDOW_HORIZONTAL) != 0 {
        size = Float(Double(item.window.rect.w) - (SCROLLBAR_SIZE * 2) - 2)
        if max > 0 {
            pos = Float((Double(size) - SCROLLBAR_SIZE) / Double(Float(max)))
        } else {
            pos = 0
        }
        // Port-note: A read of `listPtr`, a local the draft left as a hole.
        // Raven wrote: pos *= listPtr->startPos
        portMissing("Item_ListBox_ThumbPosition", source: "oracle/codemp/ui/ui_shared.c:2724")
        return Int32(Double(item.window.rect.x + 1) + SCROLLBAR_SIZE + Double(pos))
    } else {
        size = Float(Double(item.window.rect.h) - (SCROLLBAR_SIZE * 2) - 2)
        if max > 0 {
            pos = Float((Double(size) - SCROLLBAR_SIZE) / Double(Float(max)))
        } else {
            pos = 0
        }
        // Port-note: A read of `listPtr`, a local the draft left as a hole.
        // Raven wrote: pos *= listPtr->startPos
        portMissing("Item_ListBox_ThumbPosition", source: "oracle/codemp/ui/ui_shared.c:2724")
        return Int32(Double(item.window.rect.y + 1) + SCROLLBAR_SIZE + Double(pos))
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:2751
func Item_ListBox_ThumbDrawPosition(_ item: ItemDef) -> Int32 {
    let min: Int32
    let max: Int32

    if itemCapture == item {
        if (item.window.flags & WINDOW_HORIZONTAL) != 0 {
            min = Int32(Double(item.window.rect.x) + SCROLLBAR_SIZE + 1)
            max = Int32(Double(item.window.rect.x + item.window.rect.w) - 2 * SCROLLBAR_SIZE - 1)
            if Double(DC!.cursorx) >= Double(min) + SCROLLBAR_SIZE / 2 && Double(DC!.cursorx) <= Double(max) + SCROLLBAR_SIZE / 2 {
                return Int32(Double(DC!.cursorx) - SCROLLBAR_SIZE / 2)
            } else {
                return Item_ListBox_ThumbPosition(item)
            }
        } else {
            min = Int32(Double(item.window.rect.y) + SCROLLBAR_SIZE + 1)
            max = Int32(Double(item.window.rect.y + item.window.rect.h) - 2 * SCROLLBAR_SIZE - 1)
            if Double(DC!.cursory) >= Double(min) + SCROLLBAR_SIZE / 2 && Double(DC!.cursory) <= Double(max) + SCROLLBAR_SIZE / 2 {
                return Int32(Double(DC!.cursory) - SCROLLBAR_SIZE / 2)
            } else {
                return Item_ListBox_ThumbPosition(item)
            }
        }
    } else {
        return Item_ListBox_ThumbPosition(item)
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:2790
func Item_Slider_ThumbPosition(_ item: ItemDef) -> Float {
    var value: Float
    let range: Float
    var x: Float
    // Port-note: A pointer local `editFieldDef_t * editDef` with no view.
    // Raven wrote: editFieldDef_t *editDef = (editFieldDef_t *) item->typeData;
    portMissing("Item_Slider_ThumbPosition", source: "oracle/codemp/ui/ui_shared.c:2790")

    if item.text != nil {
        x = item.textRect.x + item.textRect.w + 8
    } else {
        x = item.window.rect.x
    }

    // Port-note: A read of `editDef`, a local the draft left as a hole.
    // Raven wrote: if (editDef == NULL && item->cvar) { return x; }
    portMissing("Item_Slider_ThumbPosition", source: "oracle/codemp/ui/ui_shared.c:2790")

    value = DC!.runGetCVarValue(item.cvar!)

    // Port-note: A read of `editDef`, a local the draft left as a hole.
    // Raven wrote: if (value < editDef->minVal) { value = editDef->minVal; } else if (value > editDef->maxVal) { value = editDef->maxVal; }
    portMissing("Item_Slider_ThumbPosition", source: "oracle/codemp/ui/ui_shared.c:2790")

    // Port-note: A read of `editDef`, a local the draft left as a hole.
    // Raven wrote: range = editDef->maxVal - editDef->minVal
    portMissing("Item_Slider_ThumbPosition", source: "oracle/codemp/ui/ui_shared.c:2790")
    // Port-note: A read of `editDef`, a local the draft left as a hole.
    // Raven wrote: value -= editDef->minVal
    portMissing("Item_Slider_ThumbPosition", source: "oracle/codemp/ui/ui_shared.c:2790")
    value /= range
    //value /= (editDef->maxVal - editDef->minVal);
    value = Float(Double(value) * SLIDER_WIDTH)
    x += value
    // vm fuckage
    //x = x + (((float)value / editDef->maxVal) * SLIDER_WIDTH);
    return x
}

/// Source: oracle/codemp/ui/ui_shared.c:2823
func Item_Slider_OverSlider(_ item: ItemDef, _ x: Float, _ y: Float) -> Int32 {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return RectDef.scratch { r -> Int32 in

        r.x = Float(Double(Item_Slider_ThumbPosition(item)) - (SLIDER_THUMB_WIDTH / 2))
        r.y = item.window.rect.y - 2
        r.w = Float(SLIDER_THUMB_WIDTH)
        r.h = Float(SLIDER_THUMB_HEIGHT)

        if Rect_ContainsPoint(r, x, y) {
            return WINDOW_LB_THUMB
        }
        return 0
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:2837
func Item_ListBox_OverLB(_ item: ItemDef, _ x: Float, _ y: Float) -> Int32 {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return RectDef.scratch { r -> Int32 in
        // Port-note: A pointer local `listBoxDef_t * listPtr` with no view.
        // Raven wrote: listBoxDef_t *listPtr;
        portMissing("Item_ListBox_OverLB", source: "oracle/codemp/ui/ui_shared.c:2837")
        var thumbstart: Int32 = 0
        var count: Int32 = 0

        count = DC!.runFeederCount(item.special)
        // Port-note: A store into `listPtr`, a local the draft left as a hole.
        // Raven wrote: listPtr = (listBoxDef_t*)item->typeData
        portMissing("Item_ListBox_OverLB", source: "oracle/codemp/ui/ui_shared.c:2837")
        if (item.window.flags & WINDOW_HORIZONTAL) != 0 {
            // check if on left arrow
            r.x = item.window.rect.x
            r.y = Float(Double(item.window.rect.y + item.window.rect.h) - SCROLLBAR_SIZE)
            r.w = Float(SCROLLBAR_SIZE)
            r.h = r.w
            if Rect_ContainsPoint(r, x, y) {
                return WINDOW_LB_LEFTARROW
            }

            // check if on right arrow
            r.x = Float(Double(item.window.rect.x + item.window.rect.w) - SCROLLBAR_SIZE)
            if Rect_ContainsPoint(r, x, y) {
                return WINDOW_LB_RIGHTARROW
            }

            // check if on thumb
            thumbstart = Item_ListBox_ThumbPosition(item)
            r.x = Float(thumbstart)
            if Rect_ContainsPoint(r, x, y) {
                return WINDOW_LB_THUMB
            }

            r.x = Float(Double(item.window.rect.x) + SCROLLBAR_SIZE)
            r.w = thumbstart - r.x
            if Rect_ContainsPoint(r, x, y) {
                return WINDOW_LB_PGUP
            }

            r.x = Float(Double(thumbstart) + SCROLLBAR_SIZE)
            r.w = Float(Double(item.window.rect.x + item.window.rect.w) - SCROLLBAR_SIZE)
            if Rect_ContainsPoint(r, x, y) {
                return WINDOW_LB_PGDN
            }
        } else {
            // Vertical Scroll
            // Multiple rows and columns (since it's more than twice as wide as an element)
            // Port-note: A read of `listPtr`, a local the draft left as a hole.
            // Raven wrote: if (( item->window.rect.w > (listPtr->elementWidth*2)) && (listPtr->elementStyle == LISTBOX_IMAGE)) { r.x = item->window.rect.x + item->window.rect.w - SCROLLBAR_SIZE; r.y = item->window.rect.y; r.h = r.w = SCROLLBAR_SIZE; if (Rect_ContainsPoint(&r, x, y)) { return WINDOW_LB_PGUP; } r.y = item->window.rect.y + item->window.rect.h - SCROLLBAR_SIZE; if (Rect_ContainsPoint(&r, x, y)) { return WINDOW_LB_PGDN; } thumbstart = Item_ListBox_ThumbPosition(item); r.y = thumbstart; if (Rect_ContainsPoint(&r, x, y)) { return WINDOW_LB_THUMB; } } else { r.x = item->window.rect.x + item->window.rect.w - SCROLLBAR_SIZE; r.y = item->window.rect.y; r.h = r.w = SCROLLBAR_SIZE; if (Rect_ContainsPoint(&r, x, y)) { return WINDOW_LB_LEFTARROW; } r.y = item->window.rect.y + item->window.rect.h - SCROLLBAR_SIZE; if (Rect_ContainsPoint(&r, x, y)) { return WINDOW_LB_RIGHTARROW; } thumbstart = Item_ListBox_ThumbPosition(item); r.y = thumbstart; if (Rect_ContainsPoint(&r, x, y)) { return WINDOW_LB_THUMB; } r.y = item->window.rect.y + SCROLLBAR_SIZE; r.h = thumbstart - r.y; if (Rect_ContainsPoint(&r, x, y)) { return WINDOW_LB_PGUP; } r.y = thumbstart + SCROLLBAR_SIZE; r.h = item->window.rect.y + item->window.rect.h - SCROLLBAR_SIZE; if (Rect_ContainsPoint(&r, x, y)) { return WINDOW_LB_PGDN; } }
            portMissing("Item_ListBox_OverLB", source: "oracle/codemp/ui/ui_shared.c:2837")
        }
        return 0
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:2956
func Item_ListBox_MouseEnter(_ item: ItemDef, _ x: Float, _ y: Float) {
    // Raven's record lives to the end of his block, so the block is the closure.
    RectDef.scratch { r in
        // Port-note: A pointer local `listBoxDef_t * listPtr` with no view.
        // Raven wrote: listBoxDef_t *listPtr = (listBoxDef_t*)item->typeData;
        portMissing("Item_ListBox_MouseEnter", source: "oracle/codemp/ui/ui_shared.c:2956")

        item.window.flags &= ~(WINDOW_LB_LEFTARROW | WINDOW_LB_RIGHTARROW | WINDOW_LB_THUMB | WINDOW_LB_PGUP | WINDOW_LB_PGDN)
        item.window.flags |= Item_ListBox_OverLB(item, x, y)

        if (item.window.flags & WINDOW_HORIZONTAL) != 0 {
            if !((item.window.flags & (WINDOW_LB_LEFTARROW | WINDOW_LB_RIGHTARROW | WINDOW_LB_THUMB | WINDOW_LB_PGUP | WINDOW_LB_PGDN)) != 0) {
                // check for selection hit as we have exausted buttons and thumb
                // Port-note: A read of `listPtr`, a local the draft left as a hole.
                // Raven wrote: if (listPtr->elementStyle == LISTBOX_IMAGE) { r.x = item->window.rect.x; r.y = item->window.rect.y; r.h = item->window.rect.h - SCROLLBAR_SIZE; r.w = item->window.rect.w - listPtr->drawPadding; if (Rect_ContainsPoint(&r, x, y)) { listPtr->cursorPos = (int)((x - r.x) / listPtr->elementWidth) + listPtr->startPos; if (listPtr->cursorPos >= listPtr->endPos) { listPtr->cursorPos = listPtr->endPos; } } } else { // text hit.. }
                portMissing("Item_ListBox_MouseEnter", source: "oracle/codemp/ui/ui_shared.c:2956")
            }
        } else if !((item.window.flags & (WINDOW_LB_LEFTARROW | WINDOW_LB_RIGHTARROW | WINDOW_LB_THUMB | WINDOW_LB_PGUP | WINDOW_LB_PGDN)) != 0) {
            // Window Vertical Scroll
            // Calc which element the mouse is over
            r.x = item.window.rect.x
            r.y = item.window.rect.y
            r.w = Float(Double(item.window.rect.w) - SCROLLBAR_SIZE)
            // Port-note: A read of `listPtr`, a local the draft left as a hole.
            // Raven wrote: r.h = item->window.rect.h - listPtr->drawPadding
            portMissing("Item_ListBox_MouseEnter", source: "oracle/codemp/ui/ui_shared.c:2956")
            if Rect_ContainsPoint(r, x, y) {
                // Multiple rows and columns (since it's more than twice as wide as an element)
                // Port-note: A read of `listPtr`, a local the draft left as a hole.
                // Raven wrote: if (( item->window.rect.w > (listPtr->elementWidth*2)) && (listPtr->elementStyle == LISTBOX_IMAGE)) { int row,column,rowLength; row = (int)((y - 2 - r.y) / listPtr->elementHeight); rowLength = (int) r.w / listPtr->elementWidth; column = (int)((x - r.x) / listPtr->elementWidth); listPtr->cursorPos = (row * rowLength)+column + listPtr->startPos; if (listPtr->cursorPos >= listPtr->endPos) { listPtr->cursorPos = listPtr->endPos; } } // single column else { listPtr->cursorPos = (int)((y - 2 - r.y) / listPtr->elementHeight) + listPtr->startPos; if (listPtr->cursorPos > listPtr->endPos) { listPtr->cursorPos = listPtr->endPos; } }
                portMissing("Item_ListBox_MouseEnter", source: "oracle/codemp/ui/ui_shared.c:2956")
            }
        }
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:3028
func Item_MouseEnter(_ item: ItemDef, _ x: Float, _ y: Float) {
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = RectDef.scratch { r -> Bool in
        r.copy(from: item.textRect)
        r.y -= r.h
        // in the text rect?

        // items can be enabled and disabled
        if item.disabled {
            return true
        }

        // items can be enabled and disabled based on cvars
        if (item.cvarFlags & (CVAR_ENABLE | CVAR_DISABLE)) != 0 && !Item_EnableShowViaCvar(item, CVAR_ENABLE) {
            return true
        }

        if (item.cvarFlags & (CVAR_SHOW | CVAR_HIDE)) != 0 && !Item_EnableShowViaCvar(item, CVAR_SHOW) {
            return true
        }

        //JLFMOUSE
        if Rect_ContainsPoint(r, x, y) {
            if !((item.window.flags & WINDOW_MOUSEOVERTEXT) != 0) {
                Item_RunScript(item, item.mouseEnterText!)
                item.window.flags |= WINDOW_MOUSEOVERTEXT
            }
            if !((item.window.flags & WINDOW_MOUSEOVER) != 0) {
                Item_RunScript(item, item.mouseEnter!)
                item.window.flags |= WINDOW_MOUSEOVER
            }
        } else {
            // not in the text rect
            if (item.window.flags & WINDOW_MOUSEOVERTEXT) != 0 {
                // if we were
                Item_RunScript(item, item.mouseExitText!)
                item.window.flags &= ~WINDOW_MOUSEOVERTEXT
            }
            if !((item.window.flags & WINDOW_MOUSEOVER) != 0) {
                Item_RunScript(item, item.mouseEnter!)
                item.window.flags |= WINDOW_MOUSEOVER
            }

            if item.type == ITEM_TYPE_LISTBOX {
                Item_ListBox_MouseEnter(item, x, y)
            } else if item.type == ITEM_TYPE_TEXTSCROLL {
                Item_TextScroll_MouseEnter(item, x, y)
            }
        }
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:3090
func Item_MouseLeave(_ item: ItemDef) {
    if (item.window.flags & WINDOW_MOUSEOVERTEXT) != 0 {
        Item_RunScript(item, item.mouseExitText!)
        item.window.flags &= ~WINDOW_MOUSEOVERTEXT
    }
    Item_RunScript(item, item.mouseExit!)
    item.window.flags &= ~(WINDOW_LB_RIGHTARROW | WINDOW_LB_LEFTARROW)
}

/// Source: oracle/codemp/ui/ui_shared.c:3101
func Menu_HitTest(_ menu: MenuDef, _ x: Float, _ y: Float) -> ItemDef? {
    var i: Int32
    i = 0
    while i < menu.itemCount {
        if Rect_ContainsPoint(menu.items[i]!.window.rect, x, y) {
            return menu.items[i]
        }
        i += 1
    }
    return nil
}

/// Source: oracle/codemp/ui/ui_shared.c:3111
func Item_SetMouseOver(_ item: ItemDef, _ focus: Bool) {
    if focus {
        item.window.flags |= WINDOW_MOUSEOVER
    } else {
        item.window.flags &= ~WINDOW_MOUSEOVER
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:3122
func Item_OwnerDraw_HandleKey(_ item: ItemDef, _ key: Int32) -> Bool {
    if DC!.ownerDrawHandleKey != nil {
        // yep this is an ugly hack
        if key == A_MOUSE1 || key == A_MOUSE2 {
            switch item.window.ownerDraw {
            case UI_FORCE_SIDE, UI_FORCE_RANK_HEAL, UI_FORCE_RANK_LEVITATION, UI_FORCE_RANK_SPEED, UI_FORCE_RANK_PUSH, UI_FORCE_RANK_PULL, UI_FORCE_RANK_TELEPATHY, UI_FORCE_RANK_GRIP, UI_FORCE_RANK_LIGHTNING, UI_FORCE_RANK_RAGE, UI_FORCE_RANK_PROTECT, UI_FORCE_RANK_ABSORB, UI_FORCE_RANK_TEAM_HEAL, UI_FORCE_RANK_TEAM_FORCE, UI_FORCE_RANK_DRAIN, UI_FORCE_RANK_SEE, UI_FORCE_RANK_SABERATTACK, UI_FORCE_RANK_SABERDEFEND, UI_FORCE_RANK_SABERTHROW:
                if !Rect_ContainsPoint(item.window.rect, Float(DC!.cursorx), Float(DC!.cursory)) {
                    return false
                }

            default:
                break
            }
        }


        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Float' to expected argument type 'vec3_t' (aka 'SIMD3<Float>')".
        // Raven wrote: return DC->ownerDrawHandleKey(item->window.ownerDraw, item->window.ownerDrawFlags, &item->special, key)
        portMissing("Item_OwnerDraw_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3122")
    }
    return false
}

/// Source: oracle/codemp/ui/ui_shared.c:3220
func Item_ListBox_HandleKey(_ item: ItemDef, _ key: Int32, _ down: Bool, _ force: Bool) -> Bool {
    // Port-note: A pointer local `listBoxDef_t * listPtr` with no view.
    // Raven wrote: listBoxDef_t *listPtr = (listBoxDef_t*)item->typeData;
    portMissing("Item_ListBox_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3220")
    let count: Int32 = DC!.runFeederCount(item.special)
    let max: Int32
    var viewmax: Int32
    //JLFMOUSE
    if force || (Rect_ContainsPoint(item.window.rect, Float(DC!.cursorx), Float(DC!.cursory)) && (item.window.flags & WINDOW_HASFOCUS) != 0) {
        max = Item_ListBox_MaxScroll(item)
        if (item.window.flags & WINDOW_HORIZONTAL) != 0 {
            // Port-note: A read of `listPtr`, a local the draft left as a hole.
            // Raven wrote: viewmax = (item->window.rect.w / listPtr->elementWidth)
            portMissing("Item_ListBox_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3220")
            if key == A_CURSOR_LEFT || key == A_KP_4 {
                // Port-note: A read of `listPtr`, a local the draft left as a hole.
                // Raven wrote: if (!listPtr->notselectable) { listPtr->cursorPos--; #ifdef _XBOX listPtr->startPos--; #endif if (listPtr->cursorPos < 0) { listPtr->cursorPos = 0; return qfalse; } if (listPtr->cursorPos < listPtr->startPos) { listPtr->startPos = listPtr->cursorPos; //JLF #ifndef _XBOX return qfalse; #endif } if (listPtr->cursorPos >= listPtr->startPos + viewmax) { listPtr->startPos = listPtr->cursorPos - viewmax + 1; } item->cursorPos = listPtr->cursorPos; DC->feederSelection(item->special, item->cursorPos, NULL); } else { listPtr->startPos--; if (listPtr->startPos < 0) listPtr->startPos = 0; }
                portMissing("Item_ListBox_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3220")
                return true
            }
            if key == A_CURSOR_RIGHT || key == A_KP_6 {
                // Port-note: A read of `listPtr`, a local the draft left as a hole.
                // Raven wrote: if (!listPtr->notselectable) { listPtr->cursorPos++; if (listPtr->cursorPos < listPtr->startPos) { listPtr->startPos = listPtr->cursorPos; //JLF #ifndef _XBOX return qfalse; #endif } if (listPtr->cursorPos >= count) { listPtr->cursorPos = count-1; return qfalse; } if (listPtr->cursorPos >= listPtr->startPos + viewmax) { listPtr->startPos = listPtr->cursorPos - viewmax + 1; } item->cursorPos = listPtr->cursorPos; DC->feederSelection(item->special, item->cursorPos, NULL); } else { listPtr->startPos++; if (listPtr->startPos >= count) listPtr->startPos = count-1; }
                portMissing("Item_ListBox_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3220")
                return true
            }
        } else {
            // Vertical scroll
            // Multiple rows and columns (since it's more than twice as wide as an element)
            // Port-note: A read of `listPtr`, a local the draft left as a hole.
            // Raven wrote: if (( item->window.rect.w > (listPtr->elementWidth*2)) && (listPtr->elementStyle == LISTBOX_IMAGE)) { viewmax = (item->window.rect.w / listPtr->elementWidth); } else { viewmax = (item->window.rect.h / listPtr->elementHeight); }
            portMissing("Item_ListBox_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3220")

            if key == A_CURSOR_UP || key == A_KP_8 {
                // Port-note: A read of `listPtr`, a local the draft left as a hole.
                // Raven wrote: if (!listPtr->notselectable) { listPtr->cursorPos--; if (listPtr->cursorPos < 0) { listPtr->cursorPos = 0; return qfalse; } if (listPtr->cursorPos < listPtr->startPos) { listPtr->startPos = listPtr->cursorPos; //JLF #ifndef _XBOX return qfalse; #endif } if (listPtr->cursorPos >= listPtr->startPos + viewmax) { listPtr->startPos = listPtr->cursorPos - viewmax + 1; } item->cursorPos = listPtr->cursorPos; DC->feederSelection(item->special, item->cursorPos, NULL); } else { listPtr->startPos--; if (listPtr->startPos < 0) listPtr->startPos = 0; }
                portMissing("Item_ListBox_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3220")
                return true
            }
            if key == A_CURSOR_DOWN || key == A_KP_2 {
                // Port-note: A read of `listPtr`, a local the draft left as a hole.
                // Raven wrote: if (!listPtr->notselectable) { listPtr->cursorPos++; if (listPtr->cursorPos < listPtr->startPos) { listPtr->startPos = listPtr->cursorPos; //JLF #ifndef _XBOX return qfalse; #endif } if (listPtr->cursorPos >= count) { listPtr->cursorPos = count-1; return qfalse; } if (listPtr->cursorPos >= listPtr->startPos + viewmax) { listPtr->startPos = listPtr->cursorPos - viewmax + 1; } item->cursorPos = listPtr->cursorPos; DC->feederSelection(item->special, item->cursorPos, NULL); } else { listPtr->startPos++; if (listPtr->startPos > max) listPtr->startPos = max; }
                portMissing("Item_ListBox_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3220")
                return true
            }
        }
        // mouse hit
        if key == A_MOUSE1 || key == A_MOUSE2 {
            if (item.window.flags & WINDOW_LB_LEFTARROW) != 0 {
                // Port-note: A read of `listPtr`, a local the draft left as a hole.
                // Raven wrote: listPtr->startPos--
                portMissing("Item_ListBox_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3220")
                // Port-note: A read of `listPtr`, a local the draft left as a hole.
                // Raven wrote: if (listPtr->startPos < 0) { listPtr->startPos = 0; }
                portMissing("Item_ListBox_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3220")
            } else if (item.window.flags & WINDOW_LB_RIGHTARROW) != 0 {
                // one down
                // Port-note: A read of `listPtr`, a local the draft left as a hole.
                // Raven wrote: listPtr->startPos++
                portMissing("Item_ListBox_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3220")
                // Port-note: A read of `listPtr`, a local the draft left as a hole.
                // Raven wrote: if (listPtr->startPos > max) { listPtr->startPos = max; }
                portMissing("Item_ListBox_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3220")
            } else if (item.window.flags & WINDOW_LB_PGUP) != 0 {
                // page up
                // Port-note: A read of `listPtr`, a local the draft left as a hole.
                // Raven wrote: listPtr->startPos -= viewmax
                portMissing("Item_ListBox_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3220")
                // Port-note: A read of `listPtr`, a local the draft left as a hole.
                // Raven wrote: if (listPtr->startPos < 0) { listPtr->startPos = 0; }
                portMissing("Item_ListBox_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3220")
            } else if (item.window.flags & WINDOW_LB_PGDN) != 0 {
                // page down
                // Port-note: A read of `listPtr`, a local the draft left as a hole.
                // Raven wrote: listPtr->startPos += viewmax
                portMissing("Item_ListBox_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3220")
                // Port-note: A read of `listPtr`, a local the draft left as a hole.
                // Raven wrote: if (listPtr->startPos > (max)) { listPtr->startPos = (max); }
                portMissing("Item_ListBox_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3220")
            } else if (item.window.flags & WINDOW_LB_THUMB) != 0 {
                // Display_SetCaptureItem(item);
            } else {
                // select an item
                // Port-note: A read of `listPtr`, a local the draft left as a hole.
                // Raven wrote: if (DC->realTime < lastListBoxClickTime && listPtr->doubleClick) { #endif Item_RunScript(item, listPtr->doubleClick); }
                portMissing("Item_ListBox_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3220")
                lastListBoxClickTime = DC!.realTime + DOUBLE_CLICK_DELAY
                //				if (item->cursorPos != listPtr->cursorPos)
                do {
                    let prePos: Int32 = item.cursorPos

                    // Port-note: A read of `listPtr`, a local the draft left as a hole.
                    // Raven wrote: item->cursorPos = listPtr->cursorPos
                    portMissing("Item_ListBox_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3220")

                    if !DC!.runFeederSelection(item.special, item.cursorPos, item) {
                        // Port-note: A read of `listPtr`, a local the draft left as a hole.
                        // Raven wrote: item->cursorPos = listPtr->cursorPos = prePos
                        portMissing("Item_ListBox_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3220")
                    }
                }
            }
            return true
        }
        if key == A_HOME || key == A_KP_7 {
            // home
            // Port-note: A read of `listPtr`, a local the draft left as a hole.
            // Raven wrote: listPtr->startPos = 0
            portMissing("Item_ListBox_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3220")
            return true
        }
        if key == A_END || key == A_KP_1 {
            // end
            // Port-note: A read of `listPtr`, a local the draft left as a hole.
            // Raven wrote: listPtr->startPos = max
            portMissing("Item_ListBox_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3220")
            return true
        }
        if key == A_PAGE_UP || key == A_KP_9 {
            // page up
            // Port-note: A read of `listPtr`, a local the draft left as a hole.
            // Raven wrote: if (!listPtr->notselectable) { listPtr->cursorPos -= viewmax; if (listPtr->cursorPos < 0) { listPtr->cursorPos = 0; } if (listPtr->cursorPos < listPtr->startPos) { listPtr->startPos = listPtr->cursorPos; } if (listPtr->cursorPos >= listPtr->startPos + viewmax) { listPtr->startPos = listPtr->cursorPos - viewmax + 1; } item->cursorPos = listPtr->cursorPos; DC->feederSelection(item->special, item->cursorPos, NULL); } else { listPtr->startPos -= viewmax; if (listPtr->startPos < 0) { listPtr->startPos = 0; } }
            portMissing("Item_ListBox_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3220")
            return true
        }
        if key == A_PAGE_DOWN || key == A_KP_3 {
            // page down
            // Port-note: A read of `listPtr`, a local the draft left as a hole.
            // Raven wrote: if (!listPtr->notselectable) { listPtr->cursorPos += viewmax; if (listPtr->cursorPos < listPtr->startPos) { listPtr->startPos = listPtr->cursorPos; } if (listPtr->cursorPos >= count) { listPtr->cursorPos = count-1; } if (listPtr->cursorPos >= listPtr->startPos + viewmax) { listPtr->startPos = listPtr->cursorPos - viewmax + 1; } item->cursorPos = listPtr->cursorPos; DC->feederSelection(item->special, item->cursorPos, NULL); } else { listPtr->startPos += viewmax; if (listPtr->startPos > max) { listPtr->startPos = max; } }
            portMissing("Item_ListBox_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3220")
            return true
        }
    }
    return false
}

/// Source: oracle/codemp/ui/ui_shared.c:3477
func Item_YesNo_HandleKey(_ item: ItemDef, _ key: Int32) -> Bool {
    //JLFMOUSE MPMOVED
    if Rect_ContainsPoint(item.window.rect, Float(DC!.cursorx), Float(DC!.cursory)) && (item.window.flags & WINDOW_HASFOCUS) != 0 && item.cvar != nil {
        //JLFDPAD MPMOVED
        if key == A_MOUSE1 || key == A_ENTER || key == A_MOUSE2 || key == A_MOUSE3 {
            DC!.runSetCVar(item.cvar!, va("%i", DC!.runGetCVarValue(item.cvar!) == 0))
            return true
        }
    }

    return false
}

/// Source: oracle/codemp/ui/ui_shared.c:3504
func Item_Multi_CountSettings(_ item: ItemDef) -> Int32 {
    // Port-note: A pointer local `multiDef_t * multiPtr` with no view.
    // Raven wrote: multiDef_t *multiPtr = (multiDef_t*)item->typeData;
    portMissing("Item_Multi_CountSettings", source: "oracle/codemp/ui/ui_shared.c:3504")
    // Port-note: A read of `multiPtr`, a local the draft left as a hole.
    // Raven wrote: if (multiPtr == NULL) { return 0; }
    portMissing("Item_Multi_CountSettings", source: "oracle/codemp/ui/ui_shared.c:3504")
    // Port-note: A read of `multiPtr`, a local the draft left as a hole.
    // Raven wrote: return multiPtr->count
    portMissing("Item_Multi_CountSettings", source: "oracle/codemp/ui/ui_shared.c:3504")
}

/// Source: oracle/codemp/ui/ui_shared.c:3512
func Item_Multi_FindCvarByValue(_ item: ItemDef) -> Int32 {
    var buff = CharBuf(2048)
    var value: Float = 0
    var i: Int32
    // Port-note: A pointer local `multiDef_t * multiPtr` with no view.
    // Raven wrote: multiDef_t *multiPtr = (multiDef_t*)item->typeData;
    portMissing("Item_Multi_FindCvarByValue", source: "oracle/codemp/ui/ui_shared.c:3512")
    // Port-note: A read of `multiPtr`, a local the draft left as a hole.
    // Raven wrote: if (multiPtr) { if (multiPtr->strDef) { DC->getCVarString(item->cvar, buff, sizeof(buff)); } else { value = DC->getCVarValue(item->cvar); } for (i = 0; i < multiPtr->count; i++) { if (multiPtr->strDef) { if (Q_stricmp(buff, multiPtr->cvarStr[i]) == 0) { return i; } } else { if (multiPtr->cvarValue[i] == value) { return i; } } } }
    portMissing("Item_Multi_FindCvarByValue", source: "oracle/codemp/ui/ui_shared.c:3512")
    return 0
}

/// Source: oracle/codemp/ui/ui_shared.c:3538
func Item_Multi_Setting(_ item: ItemDef) -> String {
    var buff = CharBuf(2048)
    var value: Float = 0
    var i: Int32
    // Port-note: A pointer local `multiDef_t * multiPtr` with no view.
    // Raven wrote: multiDef_t *multiPtr = (multiDef_t*)item->typeData;
    portMissing("Item_Multi_Setting", source: "oracle/codemp/ui/ui_shared.c:3538")
    // Port-note: A read of `multiPtr`, a local the draft left as a hole.
    // Raven wrote: if (multiPtr) { if (multiPtr->strDef) { if (item->cvar) { DC->getCVarString(item->cvar, buff, sizeof(buff)); } } else { if (item->cvar) // Was a cvar given? { value = DC->getCVarValue(item->cvar); } } for (i = 0; i < multiPtr->count; i++) { if (multiPtr->strDef) { if (Q_stricmp(buff, multiPtr->cvarStr[i]) == 0) { return multiPtr->cvarList[i]; } } else { if (multiPtr->cvarValue[i] == value) { return multiPtr->cvarList[i]; } } } }
    portMissing("Item_Multi_Setting", source: "oracle/codemp/ui/ui_shared.c:3538")
    return ""
}

/// Source: oracle/codemp/ui/ui_shared.c:3581
func Item_Multi_HandleKey(_ item: ItemDef, _ key: Int32) -> Bool {
    // Port-note: A pointer local `multiDef_t * multiPtr` with no view.
    // Raven wrote: multiDef_t *multiPtr = (multiDef_t*)item->typeData;
    portMissing("Item_Multi_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3581")
    // Port-note: A read of `multiPtr`, a local the draft left as a hole.
    // Raven wrote: if (multiPtr) { //JLF MPMOVED #ifndef _XBOX if (Rect_ContainsPoint(&item->window.rect, DC->cursorx, DC->cursory) && item->window.flags & WINDOW_HASFOCUS) #else if (item->window.flags & WINDOW_HASFOCUS)// JLF* && item->cvar) #endif { #ifndef _XBOX if (key == A_MOUSE1 || key == A_ENTER || key == A_MOUSE2 || key == A_MOUSE3) #else //JLFDPAD MPMOVED if ( key == A_CURSOR_RIGHT || key == A_CURSOR_LEFT) //end JLFDPAD #endif { int current = Item_Multi_FindCvarByValue(item); int max = Item_Multi_CountSettings(item); if (key == A_MOUSE2 || key == A_CURSOR_LEFT) // Xbox uses CURSOR_LEFT { current--; if ( current < 0 ) { current = max-1; } } else { current++; if ( current >= max ) { current = 0; } } if (multiPtr->strDef) { DC->setCVar(item->cvar, multiPtr->cvarStr[current]); } else { float value = multiPtr->cvarValue[current]; if (((float)((int) value)) == value) { DC->setCVar(item->cvar, va("%i", (int) value )); } else { DC->setCVar(item->cvar, va("%f", value )); } } if (item->special) {//its a feeder? DC->feederSelection(item->special, current, item); } return qtrue; } } }
    portMissing("Item_Multi_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3581")
    return false
}

// Leaving an edit field so reset it so it prints from the beginning.
/// Source: oracle/codemp/ui/ui_shared.c:3651
func Leaving_EditField(_ item: ItemDef) {
    // switching fields so reset printed text of edit field
    if (g_editingField == true) && (item.type == ITEM_TYPE_EDITFIELD) {
        // Port-note: A pointer local `editFieldDef_t * editPtr` with no view.
        // Raven wrote: editFieldDef_t *editPtr = (editFieldDef_t*)item->typeData;
        portMissing("Leaving_EditField", source: "oracle/codemp/ui/ui_shared.c:3651")
        // Port-note: A read of `editPtr`, a local the draft left as a hole.
        // Raven wrote: if (editPtr) { editPtr->paintOffset = 0; }
        portMissing("Leaving_EditField", source: "oracle/codemp/ui/ui_shared.c:3651")
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:3664
func Item_TextField_HandleKey(_ item: ItemDef, _ key: Int32) -> Bool {
    var buff = CharBuf(2048)
    var len: Int32
    var newItem: ItemDef? = nil
    // Port-note: A pointer local `editFieldDef_t * editPtr` with no view.
    // Raven wrote: editFieldDef_t *editPtr = (editFieldDef_t*)item->typeData;
    portMissing("Item_TextField_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3664")
    // Raven assigns his own `key` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var key = key

    if item.cvar != nil {
        buff[0] = 0
        // Port-note: Raven passes the buffer `buff` to the engine as a handle, and the trap takes an OpaquePointer.
        // Raven wrote: DC->getCVarString(item->cvar, buff, sizeof(buff))
        portMissing("Item_TextField_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3664")
        len = strlen(buff)
        // Port-note: A read of `editPtr`, a local the draft left as a hole.
        // Raven wrote: if (editPtr->maxChars && len > editPtr->maxChars) { len = editPtr->maxChars; }
        portMissing("Item_TextField_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3664")
        if (key & K_CHAR_FLAG) != 0 {
            key &= ~K_CHAR_FLAG


            if key == Int32(ascii: "h") - Int32(ascii: "a") + 1 {
                // ctrl-h is backspace
                if item.cursorPos > 0 {
                    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Int32' to expected argument type 'Int'".
                    // Raven wrote: memmove( &buff[item->cursorPos - 1], &buff[item->cursorPos], len + 1 - item->cursorPos)
                    portMissing("Item_TextField_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3664")
                    item.cursorPos -= 1
                    // Port-note: A read of `editPtr`, a local the draft left as a hole.
                    // Raven wrote: if (item->cursorPos < editPtr->paintOffset) { editPtr->paintOffset--; }
                    portMissing("Item_TextField_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3664")
                }
                DC!.runSetCVar(item.cvar!, String(buff))
                return true
            }


            //
            // ignore any non printable chars
            //
            if key < 32 || item.cvar == nil {
                return true
            }

            if item.type == ITEM_TYPE_NUMERICFIELD {
                if key < Int32(ascii: "0") || key > Int32(ascii: "9") {
                    return false
                }
            }

            if !DC!.runGetOverstrikeMode() {
                // Port-note: A read of `editPtr`, a local the draft left as a hole.
                // Raven wrote: if (( len == MAX_EDITFIELD - 1 ) || (editPtr->maxChars && len >= editPtr->maxChars)) { return qtrue; }
                portMissing("Item_TextField_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3664")
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Int32' to expected argument type 'Int'".
                // Raven wrote: memmove( &buff[item->cursorPos + 1], &buff[item->cursorPos], len + 1 - item->cursorPos )
                portMissing("Item_TextField_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3664")
            } else {
                // Port-note: A read of `editPtr`, a local the draft left as a hole.
                // Raven wrote: if (editPtr->maxChars && item->cursorPos >= editPtr->maxChars) { return qtrue; }
                portMissing("Item_TextField_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3664")
            }

            buff[item.cursorPos] = key

            //rww - nul-terminate!
            if item.cursorPos + 1 < 2048 {
                buff[item.cursorPos + 1] = 0
            } else {
                buff[item.cursorPos] = 0
            }

            DC!.runSetCVar(item.cvar!, String(buff))

            if item.cursorPos < len + 1 {
                item.cursorPos += 1
                // Port-note: A read of `editPtr`, a local the draft left as a hole.
                // Raven wrote: if (editPtr->maxPaintChars && item->cursorPos > editPtr->maxPaintChars) { editPtr->paintOffset++; }
                portMissing("Item_TextField_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3664")
            }
        } else {
            if key == A_DELETE || key == A_KP_PERIOD {
                if item.cursorPos < len {
                    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'CharBuf' to expected argument type 'UnsafeMutableRawPointer'".
                    // Raven wrote: memmove( buff + item->cursorPos, buff + item->cursorPos + 1, len - item->cursorPos)
                    portMissing("Item_TextField_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3664")
                    DC!.runSetCVar(item.cvar!, String(buff))
                }
                return true
            }

            if key == A_CURSOR_RIGHT || key == A_KP_6 {
                // Port-note: A read of `editPtr`, a local the draft left as a hole.
                // Raven wrote: if (editPtr->maxPaintChars && item->cursorPos >= editPtr->maxPaintChars && item->cursorPos < len) { item->cursorPos++; editPtr->paintOffset++; return qtrue; }
                portMissing("Item_TextField_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3664")
                if item.cursorPos < len {
                    item.cursorPos += 1
                }
                return true
            }

            if key == A_CURSOR_LEFT || key == A_KP_4 {
                if item.cursorPos > 0 {
                    item.cursorPos -= 1
                }
                // Port-note: A read of `editPtr`, a local the draft left as a hole.
                // Raven wrote: if (item->cursorPos < editPtr->paintOffset) { editPtr->paintOffset--; }
                portMissing("Item_TextField_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3664")
                return true
            }

            if key == A_HOME || key == A_KP_7 {
                // || ( tolower(key) == 'a' && trap_Key_IsDown( K_CTRL ) ) ) {
                item.cursorPos = 0
                // Port-note: A read of `editPtr`, a local the draft left as a hole.
                // Raven wrote: editPtr->paintOffset = 0
                portMissing("Item_TextField_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3664")
                return true
            }

            if key == A_END || key == A_KP_1 {
                // ( tolower(key) == 'e' && trap_Key_IsDown( K_CTRL ) ) ) {
                item.cursorPos = len
                // Port-note: A read of `editPtr`, a local the draft left as a hole.
                // Raven wrote: if(item->cursorPos > editPtr->maxPaintChars) { editPtr->paintOffset = len - editPtr->maxPaintChars; }
                portMissing("Item_TextField_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3664")
                return true
            }

            if key == A_INSERT || key == A_KP_0 {
                DC!.runSetOverstrikeMode(!DC!.runGetOverstrikeMode())
                return true
            }
        }

        if key == A_TAB || key == A_CURSOR_DOWN || key == A_KP_2 {
            // switching fields so reset printed text of edit field
            Leaving_EditField(item)
            g_editingField = false
            // Port-note: The draft of this statement did not compile, and the compiler wrote "missing argument label 'handle:' in call".
            // Raven wrote: newItem = Menu_SetNextCursorItem((menuDef_t *) item->parent)
            portMissing("Item_TextField_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3664")
            if newItem != nil && (newItem!.type == ITEM_TYPE_EDITFIELD || newItem!.type == ITEM_TYPE_NUMERICFIELD) {
                g_editItem = newItem
                g_editingField = true
            }
        }

        if key == A_CURSOR_UP || key == A_KP_8 {
            // switching fields so reset printed text of edit field
            Leaving_EditField(item)

            g_editingField = false
            // Port-note: The draft of this statement did not compile, and the compiler wrote "missing argument label 'handle:' in call".
            // Raven wrote: newItem = Menu_SetPrevCursorItem((menuDef_t *) item->parent)
            portMissing("Item_TextField_HandleKey", source: "oracle/codemp/ui/ui_shared.c:3664")
            if newItem != nil && (newItem!.type == ITEM_TYPE_EDITFIELD || newItem!.type == ITEM_TYPE_NUMERICFIELD) {
                g_editItem = newItem
                g_editingField = true
            }
        }

        if key == A_ENTER || key == A_KP_ENTER || key == A_ESCAPE {
            return false
        }

        return true
    }
    return false
}

/// Source: oracle/codemp/ui/ui_shared.c:3831
private func Scroll_TextScroll_AutoFunc(_ p: OpaquePointer?) {
    // Port-note: A pointer local `scrollInfo_t * si` with no view.
    // Raven wrote: scrollInfo_t *si = (scrollInfo_t*)p;
    portMissing("Scroll_TextScroll_AutoFunc", source: "oracle/codemp/ui/ui_shared.c:3831")

    // Port-note: A read of `si`, a local the draft left as a hole.
    // Raven wrote: if (DC->realTime > si->nextScrollTime) { // need to scroll which is done by simulating a click to the item // this is done a bit sideways as the autoscroll "knows" that the item is a listbox // so it calls it directly Item_TextScroll_HandleKey(si->item, si->scrollKey, qtrue, qfalse); si->nextScrollTime = DC->realTime + si->adjustValue; }
    portMissing("Scroll_TextScroll_AutoFunc", source: "oracle/codemp/ui/ui_shared.c:3831")

    // Port-note: A read of `si`, a local the draft left as a hole.
    // Raven wrote: if (DC->realTime > si->nextAdjustTime) { si->nextAdjustTime = DC->realTime + SCROLL_TIME_ADJUST; if (si->adjustValue > SCROLL_TIME_FLOOR) { si->adjustValue -= SCROLL_TIME_ADJUSTOFFSET; } }
    portMissing("Scroll_TextScroll_AutoFunc", source: "oracle/codemp/ui/ui_shared.c:3831")
}

/// Source: oracle/codemp/ui/ui_shared.c:3854
private func Scroll_TextScroll_ThumbFunc(_ p: OpaquePointer?) {
    // Port-note: A pointer local `scrollInfo_t * si` with no view.
    // Raven wrote: scrollInfo_t *si = (scrollInfo_t*)p;
    portMissing("Scroll_TextScroll_ThumbFunc", source: "oracle/codemp/ui/ui_shared.c:3854")
    // Raven's record lives to the end of his block, so the block is the closure.
    RectDef.scratch { r in
        var pos: Int32 = 0
        var max: Int32 = 0

        // Port-note: A pointer local `textScrollDef_t * scrollPtr` with no view.
        // Raven wrote: textScrollDef_t *scrollPtr = (textScrollDef_t*)si->item->typeData;
        portMissing("Scroll_TextScroll_ThumbFunc", source: "oracle/codemp/ui/ui_shared.c:3854")

        // Port-note: A read of `si`, a local the draft left as a hole.
        // Raven wrote: if (DC->cursory != si->yStart) { r.x = si->item->window.rect.x + si->item->window.rect.w - SCROLLBAR_SIZE - 1; r.y = si->item->window.rect.y + SCROLLBAR_SIZE + 1; r.h = si->item->window.rect.h - (SCROLLBAR_SIZE*2) - 2; r.w = SCROLLBAR_SIZE; max = Item_TextScroll_MaxScroll(si->item); // pos = (DC->cursory - r.y - SCROLLBAR_SIZE/2) * max / (r.h - SCROLLBAR_SIZE); if (pos < 0) { pos = 0; } else if (pos > max) { pos = max; } scrollPtr->startPos = pos; si->yStart = DC->cursory; }
        portMissing("Scroll_TextScroll_ThumbFunc", source: "oracle/codemp/ui/ui_shared.c:3854")

        // Port-note: A read of `si`, a local the draft left as a hole.
        // Raven wrote: if (DC->realTime > si->nextScrollTime) { // need to scroll which is done by simulating a click to the item // this is done a bit sideways as the autoscroll "knows" that the item is a listbox // so it calls it directly Item_TextScroll_HandleKey(si->item, si->scrollKey, qtrue, qfalse); si->nextScrollTime = DC->realTime + si->adjustValue; }
        portMissing("Scroll_TextScroll_ThumbFunc", source: "oracle/codemp/ui/ui_shared.c:3854")

        // Port-note: A read of `si`, a local the draft left as a hole.
        // Raven wrote: if (DC->realTime > si->nextAdjustTime) { si->nextAdjustTime = DC->realTime + SCROLL_TIME_ADJUST; if (si->adjustValue > SCROLL_TIME_FLOOR) { si->adjustValue -= SCROLL_TIME_ADJUSTOFFSET; } }
        portMissing("Scroll_TextScroll_ThumbFunc", source: "oracle/codemp/ui/ui_shared.c:3854")
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:3904
private func Scroll_ListBox_AutoFunc(_ p: OpaquePointer?) {
    // Port-note: A pointer local `scrollInfo_t * si` with no view.
    // Raven wrote: scrollInfo_t *si = (scrollInfo_t*)p;
    portMissing("Scroll_ListBox_AutoFunc", source: "oracle/codemp/ui/ui_shared.c:3904")
    // Port-note: A read of `si`, a local the draft left as a hole.
    // Raven wrote: if (DC->realTime > si->nextScrollTime) { // need to scroll which is done by simulating a click to the item // this is done a bit sideways as the autoscroll "knows" that the item is a listbox // so it calls it directly Item_ListBox_HandleKey(si->item, si->scrollKey, qtrue, qfalse); si->nextScrollTime = DC->realTime + si->adjustValue; }
    portMissing("Scroll_ListBox_AutoFunc", source: "oracle/codemp/ui/ui_shared.c:3904")

    // Port-note: A read of `si`, a local the draft left as a hole.
    // Raven wrote: if (DC->realTime > si->nextAdjustTime) { si->nextAdjustTime = DC->realTime + SCROLL_TIME_ADJUST; if (si->adjustValue > SCROLL_TIME_FLOOR) { si->adjustValue -= SCROLL_TIME_ADJUSTOFFSET; } }
    portMissing("Scroll_ListBox_AutoFunc", source: "oracle/codemp/ui/ui_shared.c:3904")
}

/// Source: oracle/codemp/ui/ui_shared.c:3922
private func Scroll_ListBox_ThumbFunc(_ p: OpaquePointer?) {
    // Port-note: A pointer local `scrollInfo_t * si` with no view.
    // Raven wrote: scrollInfo_t *si = (scrollInfo_t*)p;
    portMissing("Scroll_ListBox_ThumbFunc", source: "oracle/codemp/ui/ui_shared.c:3922")
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = RectDef.scratch { r -> Bool in
        var pos: Int32 = 0
        var max: Int32 = 0

        // Port-note: A pointer local `listBoxDef_t * listPtr` with no view.
        // Raven wrote: listBoxDef_t *listPtr = (listBoxDef_t*)si->item->typeData;
        portMissing("Scroll_ListBox_ThumbFunc", source: "oracle/codemp/ui/ui_shared.c:3922")
        // Port-note: A read of `si`, a local the draft left as a hole.
        // Raven wrote: if (si->item->window.flags & WINDOW_HORIZONTAL) { if (DC->cursorx == si->xStart) { return; } r.x = si->item->window.rect.x + SCROLLBAR_SIZE + 1; r.y = si->item->window.rect.y + si->item->window.rect.h - SCROLLBAR_SIZE - 1; r.h = SCROLLBAR_SIZE; r.w = si->item->window.rect.w - (SCROLLBAR_SIZE*2) - 2; max = Item_ListBox_MaxScroll(si->item); // pos = (DC->cursorx - r.x - SCROLLBAR_SIZE/2) * max / (r.w - SCROLLBAR_SIZE); if (pos < 0) { pos = 0; } else if (pos > max) { pos = max; } listPtr->startPos = pos; si->xStart = DC->cursorx; } else if (DC->cursory != si->yStart) { r.x = si->item->window.rect.x + si->item->window.rect.w - SCROLLBAR_SIZE - 1; r.y = si->item->window.rect.y + SCROLLBAR_SIZE + 1; r.h = si->item->window.rect.h - (SCROLLBAR_SIZE*2) - 2; r.w = SCROLLBAR_SIZE; max = Item_ListBox_MaxScroll(si->item); // Multiple rows and columns (since it's more than twice as wide as an element) if (( si->item->window.rect.w > (listPtr->elementWidth*2)) && (listPtr->elementStyle == LISTBOX_IMAGE)) { int rowLength, rowMax; rowLength = si->item->window.rect.w / listPtr->elementWidth; rowMax = max / rowLength; pos = (DC->cursory - r.y - SCROLLBAR_SIZE/2) * rowMax / (r.h - SCROLLBAR_SIZE); pos *= rowLength; } else { pos = (DC->cursory - r.y - SCROLLBAR_SIZE/2) * max / (r.h - SCROLLBAR_SIZE); } if (pos < 0) { pos = 0; } else if (pos > max) { pos = max; } listPtr->startPos = pos; si->yStart = DC->cursory; }
        portMissing("Scroll_ListBox_ThumbFunc", source: "oracle/codemp/ui/ui_shared.c:3922")

        // Port-note: A read of `si`, a local the draft left as a hole.
        // Raven wrote: if (DC->realTime > si->nextScrollTime) { // need to scroll which is done by simulating a click to the item // this is done a bit sideways as the autoscroll "knows" that the item is a listbox // so it calls it directly Item_ListBox_HandleKey(si->item, si->scrollKey, qtrue, qfalse); si->nextScrollTime = DC->realTime + si->adjustValue; }
        portMissing("Scroll_ListBox_ThumbFunc", source: "oracle/codemp/ui/ui_shared.c:3922")

        // Port-note: A read of `si`, a local the draft left as a hole.
        // Raven wrote: if (DC->realTime > si->nextAdjustTime) { si->nextAdjustTime = DC->realTime + SCROLL_TIME_ADJUST; if (si->adjustValue > SCROLL_TIME_FLOOR) { si->adjustValue -= SCROLL_TIME_ADJUSTOFFSET; } }
        portMissing("Scroll_ListBox_ThumbFunc", source: "oracle/codemp/ui/ui_shared.c:3922")
        return false
    }
    if earlyOut {
        return
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:3997
private func Scroll_Slider_ThumbFunc(_ p: OpaquePointer?) {
    let x: Float
    var value: Float
    var cursorx: Float
    // Port-note: A pointer local `scrollInfo_t * si` with no view.
    // Raven wrote: scrollInfo_t *si = (scrollInfo_t*)p;
    portMissing("Scroll_Slider_ThumbFunc", source: "oracle/codemp/ui/ui_shared.c:3997")
    // Port-note: A pointer local `editFieldDef_t * editDef` with no view.
    // Raven wrote: editFieldDef_t *editDef = (editFieldDef_t *) si->item->typeData;
    portMissing("Scroll_Slider_ThumbFunc", source: "oracle/codemp/ui/ui_shared.c:3997")

    // Port-note: A read of `si`, a local the draft left as a hole.
    // Raven wrote: if (si->item->text) { x = si->item->textRect.x + si->item->textRect.w + 8; } else { x = si->item->window.rect.x; }
    portMissing("Scroll_Slider_ThumbFunc", source: "oracle/codemp/ui/ui_shared.c:3997")

    cursorx = Float(DC!.cursorx)

    if cursorx < x {
        cursorx = x
    } else if Double(cursorx) > Double(x) + SLIDER_WIDTH {
        cursorx = Float(Double(x) + SLIDER_WIDTH)
    }
    value = cursorx - x
    value = Float(Double(value) / SLIDER_WIDTH)
    // Port-note: A read of `editDef`, a local the draft left as a hole.
    // Raven wrote: value *= (editDef->maxVal - editDef->minVal)
    portMissing("Scroll_Slider_ThumbFunc", source: "oracle/codemp/ui/ui_shared.c:3997")
    // Port-note: A read of `editDef`, a local the draft left as a hole.
    // Raven wrote: value += editDef->minVal
    portMissing("Scroll_Slider_ThumbFunc", source: "oracle/codemp/ui/ui_shared.c:3997")
    // Port-note: A read of `si`, a local the draft left as a hole.
    // Raven wrote: DC->setCVar(si->item->cvar, va("%f", value))
    portMissing("Scroll_Slider_ThumbFunc", source: "oracle/codemp/ui/ui_shared.c:3997")
}

/// Source: oracle/codemp/ui/ui_shared.c:4022
func Item_StartCapture(_ item: ItemDef, _ key: Int32) {
    var flags: Int32
    switch item.type {
    case ITEM_TYPE_EDITFIELD, ITEM_TYPE_NUMERICFIELD, ITEM_TYPE_LISTBOX:
        do {
            flags = Item_ListBox_OverLB(item, Float(DC!.cursorx), Float(DC!.cursory))
            if (flags & (WINDOW_LB_LEFTARROW | WINDOW_LB_RIGHTARROW)) != 0 {
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'scrollInfo' in scope".
                // Raven wrote: scrollInfo.nextScrollTime = DC->realTime + SCROLL_TIME_START
                portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'scrollInfo' in scope".
                // Raven wrote: scrollInfo.nextAdjustTime = DC->realTime + SCROLL_TIME_ADJUST
                portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'scrollInfo' in scope".
                // Raven wrote: scrollInfo.adjustValue = SCROLL_TIME_START
                portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'scrollInfo' in scope".
                // Raven wrote: scrollInfo.scrollKey = key
                portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Bool' to expected argument type 'Int'".
                // Raven wrote: scrollInfo.scrollDir = (flags & WINDOW_LB_LEFTARROW) ? qtrue : qfalse
                portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'scrollInfo' in scope".
                // Raven wrote: scrollInfo.item = item
                portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'scrollInfo' in scope".
                // Raven wrote: captureData = &scrollInfo
                portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'captureFunc' in scope".
                // Raven wrote: captureFunc = &Scroll_ListBox_AutoFunc
                portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
                itemCapture = item
            } else if (flags & WINDOW_LB_THUMB) != 0 {
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'scrollInfo' in scope".
                // Raven wrote: scrollInfo.scrollKey = key
                portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'scrollInfo' in scope".
                // Raven wrote: scrollInfo.item = item
                portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'scrollInfo' in scope".
                // Raven wrote: scrollInfo.xStart = DC->cursorx
                portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'scrollInfo' in scope".
                // Raven wrote: scrollInfo.yStart = DC->cursory
                portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'scrollInfo' in scope".
                // Raven wrote: captureData = &scrollInfo
                portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'captureFunc' in scope".
                // Raven wrote: captureFunc = &Scroll_ListBox_ThumbFunc
                portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
                itemCapture = item
            }
            break
        }
        fallthrough

    case ITEM_TYPE_TEXTSCROLL:
        flags = Item_TextScroll_OverLB(item, Float(DC!.cursorx), Float(DC!.cursory))
        if (flags & (WINDOW_LB_LEFTARROW | WINDOW_LB_RIGHTARROW)) != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'scrollInfo' in scope".
            // Raven wrote: scrollInfo.nextScrollTime = DC->realTime + SCROLL_TIME_START
            portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'scrollInfo' in scope".
            // Raven wrote: scrollInfo.nextAdjustTime = DC->realTime + SCROLL_TIME_ADJUST
            portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'scrollInfo' in scope".
            // Raven wrote: scrollInfo.adjustValue = SCROLL_TIME_START
            portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'scrollInfo' in scope".
            // Raven wrote: scrollInfo.scrollKey = key
            portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Bool' to expected argument type 'Int'".
            // Raven wrote: scrollInfo.scrollDir = (flags & WINDOW_LB_LEFTARROW) ? qtrue : qfalse
            portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'scrollInfo' in scope".
            // Raven wrote: scrollInfo.item = item
            portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'scrollInfo' in scope".
            // Raven wrote: captureData = &scrollInfo
            portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'captureFunc' in scope".
            // Raven wrote: captureFunc = &Scroll_TextScroll_AutoFunc
            portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
            itemCapture = item
        } else if (flags & WINDOW_LB_THUMB) != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'scrollInfo' in scope".
            // Raven wrote: scrollInfo.scrollKey = key
            portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'scrollInfo' in scope".
            // Raven wrote: scrollInfo.item = item
            portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'scrollInfo' in scope".
            // Raven wrote: scrollInfo.xStart = DC->cursorx
            portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'scrollInfo' in scope".
            // Raven wrote: scrollInfo.yStart = DC->cursory
            portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'scrollInfo' in scope".
            // Raven wrote: captureData = &scrollInfo
            portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'captureFunc' in scope".
            // Raven wrote: captureFunc = &Scroll_TextScroll_ThumbFunc
            portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
            itemCapture = item
        }

    case ITEM_TYPE_SLIDER:
        do {
            flags = Item_Slider_OverSlider(item, Float(DC!.cursorx), Float(DC!.cursory))
            if (flags & WINDOW_LB_THUMB) != 0 {
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'scrollInfo' in scope".
                // Raven wrote: scrollInfo.scrollKey = key
                portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'scrollInfo' in scope".
                // Raven wrote: scrollInfo.item = item
                portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'scrollInfo' in scope".
                // Raven wrote: scrollInfo.xStart = DC->cursorx
                portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'scrollInfo' in scope".
                // Raven wrote: scrollInfo.yStart = DC->cursory
                portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'scrollInfo' in scope".
                // Raven wrote: captureData = &scrollInfo
                portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'captureFunc' in scope".
                // Raven wrote: captureFunc = &Scroll_Slider_ThumbFunc
                portMissing("Item_StartCapture", source: "oracle/codemp/ui/ui_shared.c:4022")
                itemCapture = item
            }
            break
        }

    default:
        break
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:4097
func Item_StopCapture(_ item: ItemDef) {
}

/// Source: oracle/codemp/ui/ui_shared.c:4101
func Item_Slider_HandleKey(_ item: ItemDef, _ key: Int32, _ down: Bool) -> Bool {
    var x: Float = 0
    var value: Float = 0
    var width: Float = 0
    var work: Float = 0

    //DC->Print("slider handle key\n");
    //JLF MPMOVED
    if (item.window.flags & WINDOW_HASFOCUS) != 0 && item.cvar != nil && Rect_ContainsPoint(item.window.rect, Float(DC!.cursorx), Float(DC!.cursory)) {
        if key == A_MOUSE1 || key == A_ENTER || key == A_MOUSE2 || key == A_MOUSE3 {
            // Port-note: A pointer local `editFieldDef_t * editDef` with no view.
            // Raven wrote: editFieldDef_t *editDef = (editFieldDef_t *) item->typeData;
            portMissing("Item_Slider_HandleKey", source: "oracle/codemp/ui/ui_shared.c:4101")
            // Port-note: A read of `editDef`, a local the draft left as a hole.
            // Raven wrote: if (editDef) { rectDef_t testRect; width = SLIDER_WIDTH; if (item->text) { x = item->textRect.x + item->textRect.w + 8; } else { x = item->window.rect.x; } testRect = item->window.rect; testRect.x = x; value = (float)SLIDER_THUMB_WIDTH / 2; testRect.x -= value; //DC->Print("slider x: %f\n", testRect.x); testRect.w = (SLIDER_WIDTH + (float)SLIDER_THUMB_WIDTH / 2); //DC->Print("slider w: %f\n", testRect.w); if (Rect_ContainsPoint(&testRect, DC->cursorx, DC->cursory)) { work = DC->cursorx - x; value = work / width; value *= (editDef->maxVal - editDef->minVal); // vm fuckage // value = (((float)(DC->cursorx - x)/ SLIDER_WIDTH) * (editDef->maxVal - editDef->minVal)); value += editDef->minVal; DC->setCVar(item->cvar, va("%f", value)); return qtrue; } }
            portMissing("Item_Slider_HandleKey", source: "oracle/codemp/ui/ui_shared.c:4101")
        }
    }
    //JLF
    DC!.runPrint("slider handle key exit\n")
    return false
}

/// Source: oracle/codemp/ui/ui_shared.c:4176
func Item_HandleKey(_ item: ItemDef, _ key: Int32, _ down: Bool) -> Bool {
    if itemCapture != nil {
        Item_StopCapture(itemCapture!)
        itemCapture = nil
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'captureFunc' in scope".
        // Raven wrote: captureFunc = 0
        portMissing("Item_HandleKey", source: "oracle/codemp/ui/ui_shared.c:4176")
        captureData = nil
    } else {
        // bk001206 - parentheses
        if down && (key == A_MOUSE1 || key == A_MOUSE2 || key == A_MOUSE3) {
            Item_StartCapture(item, key)
        }
    }

    if !down {
        return false
    }

    switch item.type {
    case ITEM_TYPE_BUTTON:
        return false

    case ITEM_TYPE_RADIOBUTTON:
        return false

    case ITEM_TYPE_CHECKBOX:
        return false

    case ITEM_TYPE_EDITFIELD, ITEM_TYPE_NUMERICFIELD:
        if key == A_MOUSE1 || key == A_MOUSE2 || key == A_ENTER {
            // Port-note: A pointer local `editFieldDef_t * editPtr` with no view.
            // Raven wrote: editFieldDef_t *editPtr = (editFieldDef_t*)item->typeData;
            portMissing("Item_HandleKey", source: "oracle/codemp/ui/ui_shared.c:4176")

            // Port-note: A read of `editPtr`, a local the draft left as a hole.
            // Raven wrote: if (item->cvar && editPtr) { editPtr->paintOffset = 0; }
            portMissing("Item_HandleKey", source: "oracle/codemp/ui/ui_shared.c:4176")

            //return Item_TextField_HandleKey(item, key);
        }
        return false

    case ITEM_TYPE_COMBO:
        return false

    case ITEM_TYPE_LISTBOX:
        return Item_ListBox_HandleKey(item, key, down, false)

    case ITEM_TYPE_TEXTSCROLL:
        return Item_TextScroll_HandleKey(item, key, down, false)

    case ITEM_TYPE_YESNO:
        return Item_YesNo_HandleKey(item, key)

    case ITEM_TYPE_MULTI:
        return Item_Multi_HandleKey(item, key)

    case ITEM_TYPE_OWNERDRAW:
        return Item_OwnerDraw_HandleKey(item, key)

    case ITEM_TYPE_BIND:
        return Item_Bind_HandleKey(item, key, down)

    case ITEM_TYPE_SLIDER:
        return Item_Slider_HandleKey(item, key, down)
        //case ITEM_TYPE_IMAGE:
        //  Item_Image_Paint(item);
        //  break;

    default:
        return false
    }

    //return qfalse;
}

//JLFACCEPT MPMOVED
/**
```
-----------------------------------------
Item_HandleAccept
	If Item has an accept script, run it.
-------------------------------------------
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:4271
func Item_HandleAccept(_ item: ItemDef) -> Bool {
    if item.accept != nil {
        Item_RunScript(item, item.accept!)
        return true
    }
    return false
}

/// Source: oracle/codemp/ui/ui_shared.c:4321
func Item_Action(_ item: ItemDef) {
    Item_RunScript(item, item.action!)
}

/// Source: oracle/codemp/ui/ui_shared.c:4329
func Menu_SetPrevCursorItem(_ menu: MenuDef) -> ItemDef? {
    var wrapped: Bool = false
    let oldCursor: Int32 = menu.cursorItem

    if menu.cursorItem < 0 {
        menu.cursorItem = menu.itemCount - 1
        wrapped = true
    }

    while menu.cursorItem > -1 {
        menu.cursorItem -= 1
        if menu.cursorItem < 0 {
            if wrapped {
                break
            }
            wrapped = true
            menu.cursorItem = menu.itemCount - 1
        }

        if Item_SetFocus(menu.items[menu.cursorItem]!, Float(DC!.cursorx), Float(DC!.cursory)) {
            Menu_HandleMouseMove(menu, menu.items[menu.cursorItem]!.window.rect.x + 1, menu.items[menu.cursorItem]!.window.rect.y + 1)
            return menu.items[menu.cursorItem]
        }
    }
    menu.cursorItem = oldCursor
    return nil
}

/// Source: oracle/codemp/ui/ui_shared.c:4360
func Menu_SetNextCursorItem(_ menu: MenuDef) -> ItemDef? {
    var wrapped: Bool = false
    let oldCursor: Int32 = menu.cursorItem


    if menu.cursorItem == -1 {
        menu.cursorItem = 0
        wrapped = true
    }

    while menu.cursorItem < menu.itemCount {
        menu.cursorItem += 1
        if menu.cursorItem >= menu.itemCount && !wrapped {
            wrapped = true
            menu.cursorItem = 0
        }
        if Item_SetFocus(menu.items[menu.cursorItem]!, Float(DC!.cursorx), Float(DC!.cursory)) {
            Menu_HandleMouseMove(menu, menu.items[menu.cursorItem]!.window.rect.x + 1, menu.items[menu.cursorItem]!.window.rect.y + 1)
            return menu.items[menu.cursorItem]
        }
    }

    menu.cursorItem = oldCursor
    return nil
}

/// Source: oracle/codemp/ui/ui_shared.c:4389
private func Window_CloseCinematic(_ window: JKAMP.WindowDef) {
    if window.style == WINDOW_STYLE_CINEMATIC && window.cinematic >= 0 {
        DC!.runStopCinematic(window.cinematic)
        window.cinematic = -1
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:4396
private func Menu_CloseCinematics(_ menu: MenuDef) {
    var i: Int32
    Window_CloseCinematic(menu.window)
    i = 0
    while i < menu.itemCount {
        Window_CloseCinematic(menu.items[i]!.window)
        if menu.items[i]!.type == ITEM_TYPE_OWNERDRAW {
            DC!.runStopCinematic(0 - menu.items[i]!.window.ownerDraw)
        }
        i += 1
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:4409
private func Display_CloseCinematics() {
    var i: Int32
    i = 0
    while i < menuCount {
        Menu_CloseCinematics(Menus[i])
        i += 1
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:4416
func Menus_Activate(_ menu: MenuDef) {
    //JLFCALLOUT MPMOVED
    //JLF END
    menu.window.flags |= (WINDOW_HASFOCUS | WINDOW_VISIBLE)
    if menu.onOpen != nil {
        // Raven's record lives to the end of his block, so the block is the closure.
        ItemDef.scratch { item in
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot assign value of type 'MenuDef' to type 'OpaquePointer'".
            // Raven wrote: item.parent = menu
            portMissing("Menus_Activate", source: "oracle/codemp/ui/ui_shared.c:4416")
            Item_RunScript(item, menu.onOpen!)
        }
    }

    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: if (menu->soundName && *menu->soundName) { // DC->stopBackgroundTrack(); // you don't want to do this since it will reset s_rawend DC->startBackgroundTrack(menu->soundName, menu->soundName, qfalse); }
    portMissing("Menus_Activate", source: "oracle/codemp/ui/ui_shared.c:4416")

    menu.appearanceTime = 0
    Display_CloseCinematics()
}

/// Source: oracle/codemp/ui/ui_shared.c:4442
func Display_VisibleMenuCount() -> Int32 {
    var i: Int32
    var count: Int32
    count = 0
    i = 0
    while i < menuCount {
        if (Menus[i].window.flags & (WINDOW_FORCED | WINDOW_VISIBLE)) != 0 {
            count += 1
        }
        i += 1
    }
    return count
}

/// Source: oracle/codemp/ui/ui_shared.c:4453
func Menus_HandleOOBClick(_ menu: MenuDef, _ key: Int32, _ down: Bool) {
    //JLFMOUSE
    var i: Int32
    // basically the behaviour we are looking for is if there are windows in the stack.. see if
    // the cursor is within any of them.. if not close them otherwise activate them and pass the
    // key on.. force a mouse move to activate focus and script stuff
    if down && (menu.window.flags & WINDOW_OOB_CLICK) != 0 {
        Menu_RunCloseScript(menu)
        menu.window.flags &= ~(WINDOW_HASFOCUS | WINDOW_VISIBLE)
    }

    i = 0
    while i < menuCount {
        if Menu_OverActiveItem(Menus[i], Float(DC!.cursorx), Float(DC!.cursory)) {
            Menu_RunCloseScript(menu)
            menu.window.flags &= ~(WINDOW_HASFOCUS | WINDOW_VISIBLE)
            Menus_Activate(Menus[i])
            Menu_HandleMouseMove(Menus[i], Float(DC!.cursorx), Float(DC!.cursory))
            Menu_HandleKey(Menus[i], key, down)
        }
        i += 1
    }

    if Display_VisibleMenuCount() == 0 {
        if DC!.Pause != nil {
            DC!.runPause(false)
        }
    }
    Display_CloseCinematics()
}

/// Source: oracle/codemp/ui/ui_shared.c:4490
func Menu_HandleKey(_ menu: MenuDef, _ key: Int32, _ down: Bool) {
    var i: Int32 = 0
    var item: ItemDef? = nil
    var inHandler: Bool = false

    if inHandler {
        return
    }

    inHandler = true
    if g_waitingForKey && down {
        Item_Bind_HandleKey(g_bindItem!, key, down)
        inHandler = false
        return
    }

    if g_editingField && down {
        if !Item_TextField_HandleKey(g_editItem!, key) {
            g_editingField = false
            g_editItem = nil
            inHandler = false
            return
        } else if key == A_MOUSE1 || key == A_MOUSE2 || key == A_MOUSE3 {
            // switching fields so reset printed text of edit field
            Leaving_EditField(g_editItem!)
            g_editingField = false
            g_editItem = nil
            Display_MouseMove(nil, DC!.cursorx, DC!.cursory)
        } else if key == A_TAB || key == A_CURSOR_UP || key == A_CURSOR_DOWN {
            return
        }
    }

    if menu == nil {
        inHandler = false
        return
    }
    //JLFMOUSE
    // see if the mouse is within the window bounds and if so is this a mouse click
    if down && !((menu.window.flags & WINDOW_POPUP) != 0) && !Rect_ContainsPoint(menu.window.rect, Float(DC!.cursorx), Float(DC!.cursory)) {
        // Port-note: A static local `inHandleKey` a statement reads before it writes, storage that outlives the call.
        // Raven wrote: static qboolean inHandleKey = qfalse;
        portMissing("Menu_HandleKey", source: "oracle/codemp/ui/ui_shared.c:4490")
        // bk001206 - parentheses
        // Port-note: A read of `inHandleKey`, a local the draft left as a hole.
        // Raven wrote: if (!inHandleKey && ( key == A_MOUSE1 || key == A_MOUSE2 || key == A_MOUSE3 ) ) { inHandleKey = qtrue; Menus_HandleOOBClick(menu, key, down); inHandleKey = qfalse; inHandler = qfalse; return; }
        portMissing("Menu_HandleKey", source: "oracle/codemp/ui/ui_shared.c:4490")
    }

    // get the item with focus
    i = 0
    while i < menu.itemCount {
        if (menu.items[i]!.window.flags & WINDOW_HASFOCUS) != 0 {
            item = menu.items[i]
        }
        i += 1
    }

    // Ignore if disabled
    if item != nil && item!.disabled {
        return
    }

    if item != nil {
        if Item_HandleKey(item!, key, down) {
            // It is possible for an item to be disable after Item_HandleKey is run (like in Voice Chat)
            if !item!.disabled {
                Item_Action(item!)
            }
            inHandler = false
            return
        }
    }

    if !down {
        inHandler = false
        return
    }

    // default handling
    switch key {
    case A_F11:
        if DC!.runGetCVarValue("developer") != 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Bool' to expected argument type 'Int'".
            // Raven wrote: debugMode ^= 1
            portMissing("Menu_HandleKey", source: "oracle/codemp/ui/ui_shared.c:4490")
        }

    case A_F12:
        if DC!.runGetCVarValue("developer") != 0 {
            DC!.runExecuteText(EXEC_APPEND, "screenshot\n")
        }

    case A_KP_8, A_CURSOR_UP:
        Menu_SetPrevCursorItem(menu)

    case A_ESCAPE:
        if !g_waitingForKey && menu.onESC != nil {
            // Raven's record lives to the end of his block, so the block is the closure.
            ItemDef.scratch { it in
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot assign value of type 'MenuDef' to type 'OpaquePointer'".
                // Raven wrote: it.parent = menu
                portMissing("Menu_HandleKey", source: "oracle/codemp/ui/ui_shared.c:4490")
                Item_RunScript(it, menu.onESC!)
            }
        }
        g_waitingForKey = false

    case A_TAB, A_KP_2, A_CURSOR_DOWN:
        Menu_SetNextCursorItem(menu)

    case A_MOUSE1, A_MOUSE2:
        if item != nil {
            if item!.type == ITEM_TYPE_TEXT {
                //JLFMOUSE
                if Rect_ContainsPoint(item!.window.rect, Float(DC!.cursorx), Float(DC!.cursory)) {
                    Item_Action(item!)
                }
            } else if item!.type == ITEM_TYPE_EDITFIELD || item!.type == ITEM_TYPE_NUMERICFIELD {
                //JLFMOUSE
                if Rect_ContainsPoint(item!.window.rect, Float(DC!.cursorx), Float(DC!.cursory)) {
                    Item_Action(item!)
                    item!.cursorPos = 0
                    g_editingField = true
                    g_editItem = item
                    DC!.runSetOverstrikeMode(true)
                }
            } else if item!.type == ITEM_TYPE_MULTI || item!.type == ITEM_TYPE_YESNO || item!.type == ITEM_TYPE_SLIDER {
                //JLFACCEPT
                // add new types here as needed
                /* Notes:
                Most controls will use the dpad to move through the selection possibilies.  Buttons are the only exception.
                Buttons will be assumed to all be on one menu together.  If the start or A button is pressed on a control focus, that
                means that the menu is accepted and move onto the next menu.  If the start or A button is pressed on a button focus it
                should just process the action and not support the accept functionality.
                */
                //JLFACCEPT MPMOVED
                if Item_HandleAccept(item!) {
                    //Item processed it overriding the menu processing
                    return
                } else if menu.onAccept != nil {
                    // Raven's record lives to the end of his block, so the block is the closure.
                    ItemDef.scratch { it in
                        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot assign value of type 'MenuDef' to type 'OpaquePointer'".
                        // Raven wrote: it.parent = menu
                        portMissing("Menu_HandleKey", source: "oracle/codemp/ui/ui_shared.c:4490")
                        Item_RunScript(it, menu.onAccept!)
                    }
                }
            } else {
                //END JLFACCEPT
                //JLFMOUSE
                if Rect_ContainsPoint(item!.window.rect, Float(DC!.cursorx), Float(DC!.cursory)) {
                    Item_Action(item!)
                }
            }
        }

    case A_JOY0, A_JOY1, A_JOY2, A_JOY3, A_JOY4, A_AUX0, A_AUX1, A_AUX2, A_AUX3, A_AUX4, A_AUX5, A_AUX6, A_AUX7, A_AUX8, A_AUX9, A_AUX10, A_AUX11, A_AUX12, A_AUX13, A_AUX14, A_AUX15, A_AUX16:
        break

    case A_KP_ENTER, A_ENTER:
        if item != nil {
            if item!.type == ITEM_TYPE_EDITFIELD || item!.type == ITEM_TYPE_NUMERICFIELD {
                item!.cursorPos = 0
                g_editingField = true
                g_editItem = item
                DC!.runSetOverstrikeMode(true)
            } else {
                Item_Action(item!)
            }
        }

    default:
        break
    }
    inHandler = false
}

/// Source: oracle/codemp/ui/ui_shared.c:4727
func ToWindowCoords(_ x: inout Float, _ y: inout Float, _ window: JKAMP.WindowDef) {
    if window.border != 0 {
        x += window.borderSize
        y += window.borderSize
    }
    x += window.rect.x
    y += window.rect.y
}

/// Source: oracle/codemp/ui/ui_shared.c:4736
func Rect_ToWindowCoords(_ rect: JKAMP.RectDef, _ window: JKAMP.WindowDef) {
    ToWindowCoords(&rect.x, &rect.y, window)
}

/// Source: oracle/codemp/ui/ui_shared.c:4740
func Item_SetTextExtents(_ item: ItemDef, _ width: inout Int32, _ height: inout Int32, _ text: String) {
    // Port-note: A pointer local `const char * textPtr` with no view.
    // Raven wrote: const char *textPtr = (text) ? text : item->text;
    portMissing("Item_SetTextExtents", source: "oracle/codemp/ui/ui_shared.c:4740")

    // Port-note: A read of `textPtr`, a local the draft left as a hole.
    // Raven wrote: if (textPtr == NULL ) { return; }
    portMissing("Item_SetTextExtents", source: "oracle/codemp/ui/ui_shared.c:4740")

    width = Int32(item.textRect.w)
    height = Int32(item.textRect.h)

    // keeps us from computing the widths and heights more than once
    // Port-note: The draft of this statement did not compile, and the compiler wrote "ambiguous use of 'ITEM_ALIGN_CENTER'".
    // Raven wrote: if (*width == 0 || (item->type == ITEM_TYPE_OWNERDRAW && item->textalignment == ITEM_ALIGN_CENTER) #ifndef CGAME || (item->text && item->text[0]=='@' && item->asset != se_language.modificationCount ) //string package language changed #endif ) { int originalWidth = DC->textWidth(textPtr, item->textscale, item->iMenuFont); if (item->type == ITEM_TYPE_OWNERDRAW && (item->textalignment == ITEM_ALIGN_CENTER || item->textalignment == ITEM_ALIGN_RIGHT)) { originalWidth += DC->ownerDrawWidth(item->window.ownerDraw, item->textscale); } else if (item->type == ITEM_TYPE_EDITFIELD && item->textalignment == ITEM_ALIGN_CENTER && item->cvar) { char buff[256]; DC->getCVarString(item->cvar, buff, 256); originalWidth += DC->textWidth(buff, item->textscale, item->iMenuFont); } *width = DC->textWidth(textPtr, item->textscale, item->iMenuFont); *height = DC->textHeight(textPtr, item->textscale, item->iMenuFont); item->textRect.w = *width; item->textRect.h = *height; item->textRect.x = item->textalignx; item->textRect.y = item->textaligny; if (item->textalignment == ITEM_ALIGN_RIGHT) { item->textRect.x = item->textalignx - originalWidth; } else if (item->textalignment == ITEM_ALIGN_CENTER) { item->textRect.x = item->textalignx - originalWidth / 2; } ToWindowCoords(&item->textRect.x, &item->textRect.y, &item->window); #ifndef CGAME if (item->text && item->text[0]=='@' )//string package {//mark language item->asset = se_language.modificationCount; } #endif }
    portMissing("Item_SetTextExtents", source: "oracle/codemp/ui/ui_shared.c:4740")
}

/// Source: oracle/codemp/ui/ui_shared.c:4793
func Item_TextColor(_ item: ItemDef, _ newColor: inout JKAShared.vec4_t) {
    var lowLight = vec4_t()
    // Port-note: The draft of this statement did not compile, and the compiler wrote "missing argument label 'handle:' in call".
    // Raven wrote: menuDef_t *parent = (menuDef_t*)item->parent;
    portMissing("Item_TextColor", source: "oracle/codemp/ui/ui_shared.c:4793")

    // Port-note: A read of `parent`, a local the draft left as a hole.
    // Raven wrote: Fade(&item->window.flags, &item->window.foreColor[3], parent->fadeClamp, &item->window.nextTime, parent->fadeCycle, qtrue, parent->fadeAmount)
    portMissing("Item_TextColor", source: "oracle/codemp/ui/ui_shared.c:4793")

    if (item.window.flags & WINDOW_HASFOCUS) != 0 {
        // Port-note: A read of `parent`, a local the draft left as a hole.
        // Raven wrote: lowLight[0] = 0.8 * parent->focusColor[0]
        portMissing("Item_TextColor", source: "oracle/codemp/ui/ui_shared.c:4793")
        // Port-note: A read of `parent`, a local the draft left as a hole.
        // Raven wrote: lowLight[1] = 0.8 * parent->focusColor[1]
        portMissing("Item_TextColor", source: "oracle/codemp/ui/ui_shared.c:4793")
        // Port-note: A read of `parent`, a local the draft left as a hole.
        // Raven wrote: lowLight[2] = 0.8 * parent->focusColor[2]
        portMissing("Item_TextColor", source: "oracle/codemp/ui/ui_shared.c:4793")
        // Port-note: A read of `parent`, a local the draft left as a hole.
        // Raven wrote: lowLight[3] = 0.8 * parent->focusColor[3]
        portMissing("Item_TextColor", source: "oracle/codemp/ui/ui_shared.c:4793")
        // Port-note: A read of `parent`, a local the draft left as a hole.
        // Raven wrote: LerpColor(parent->focusColor,lowLight,*newColor,0.5+0.5*sin((float)(DC->realTime / PULSE_DIVISOR)))
        portMissing("Item_TextColor", source: "oracle/codemp/ui/ui_shared.c:4793")
    } else if item.textStyle == ITEM_TEXTSTYLE_BLINK && !(((DC!.realTime / BLINK_DIVISOR) & 1) != 0) {
        lowLight[0] = Float(0.8 * Double(item.window.foreColor[0]))
        lowLight[1] = Float(0.8 * Double(item.window.foreColor[1]))
        lowLight[2] = Float(0.8 * Double(item.window.foreColor[2]))
        lowLight[3] = Float(0.8 * Double(item.window.foreColor[3]))
        LerpColor(vec4_t(item.window.foreColor[0], item.window.foreColor[1], item.window.foreColor[2], item.window.foreColor[3]), lowLight, &newColor, Float(0.5 + 0.5 * sin(Double(Float((DC!.realTime / PULSE_DIVISOR))))))
    } else {
        // Port-note: Raven's `memcpy(newColor, &item->window.foreColor, sizeof(vec4_t))` runs over bytes that are not one record with a view.
        // Raven wrote: memcpy(newColor, &item->window.foreColor, sizeof(vec4_t))
        portMissing("Item_TextColor", source: "oracle/codemp/ui/ui_shared.c:4793")
        // items can be enabled and disabled based on cvars
    }

    if item.disabled {
        // Port-note: Raven's `memcpy(newColor, &parent->disableColor, sizeof(vec4_t))` runs over bytes that are not one record with a view.
        // Raven wrote: memcpy(newColor, &parent->disableColor, sizeof(vec4_t))
        portMissing("Item_TextColor", source: "oracle/codemp/ui/ui_shared.c:4793")
    }

    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: if (item->enableCvar && *item->enableCvar && item->cvarTest && *item->cvarTest) { if (item->cvarFlags & (CVAR_ENABLE | CVAR_DISABLE) && !Item_EnableShowViaCvar(item, CVAR_ENABLE)) { memcpy(newColor, &parent->disableColor, sizeof(vec4_t)); } }
    portMissing("Item_TextColor", source: "oracle/codemp/ui/ui_shared.c:4793")
}

/// Source: oracle/codemp/ui/ui_shared.c:4828
func Item_Text_AutoWrapped_Paint(_ item: ItemDef) {
    var text = CharBuf(2048)
    // Port-note: A pointer local `const char * p` with no view.
    // Raven wrote: const char *p;
    portMissing("Item_Text_AutoWrapped_Paint", source: "oracle/codemp/ui/ui_shared.c:4828")
    // Port-note: A pointer local `const char * textPtr` with no view.
    // Raven wrote: textPtr;
    portMissing("Item_Text_AutoWrapped_Paint", source: "oracle/codemp/ui/ui_shared.c:4828")
    // Port-note: A pointer local `const char * newLinePtr` with no view.
    // Raven wrote: newLinePtr;
    portMissing("Item_Text_AutoWrapped_Paint", source: "oracle/codemp/ui/ui_shared.c:4828")
    var buff = CharBuf(2048)
    let height: Int32
    var len: Int32
    var textWidth: Int32
    var newLine: Int32
    var newLineWidth: Int32
    var y: Float
    var color = vec4_t()

    textWidth = 0
    // Port-note: A store into `newLinePtr`, a local the draft left as a hole.
    // Raven wrote: newLinePtr = NULL
    portMissing("Item_Text_AutoWrapped_Paint", source: "oracle/codemp/ui/ui_shared.c:4828")

    if item.text == nil {
        if item.cvar == nil {
            return
        } else {
            // Port-note: Raven passes the buffer `text` to the engine as a handle, and the trap takes an OpaquePointer.
            // Raven wrote: DC->getCVarString(item->cvar, text, sizeof(text))
            portMissing("Item_Text_AutoWrapped_Paint", source: "oracle/codemp/ui/ui_shared.c:4828")
            // Port-note: A store into `textPtr`, a local the draft left as a hole.
            // Raven wrote: textPtr = text
            portMissing("Item_Text_AutoWrapped_Paint", source: "oracle/codemp/ui/ui_shared.c:4828")
        }
    } else {
        // Port-note: A store into `textPtr`, a local the draft left as a hole.
        // Raven wrote: textPtr = item->text
        portMissing("Item_Text_AutoWrapped_Paint", source: "oracle/codemp/ui/ui_shared.c:4828")
    }
    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: if (*textPtr == '@') // string reference { trap_SP_GetStringTextString( &textPtr[1], text, sizeof(text)); textPtr = text; }
    portMissing("Item_Text_AutoWrapped_Paint", source: "oracle/codemp/ui/ui_shared.c:4828")
    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: if (*textPtr == '\0') { return; }
    portMissing("Item_Text_AutoWrapped_Paint", source: "oracle/codemp/ui/ui_shared.c:4828")
    Item_TextColor(item, &color)
    //Item_SetTextExtents(item, &width, &height, textPtr);
    //if (item->value == 0)
    //{
    //	item->value = (int)(0.5 + (float)DC->textWidth(textPtr, item->textscale, item->font) / item->window.rect.w);
    //}
    // Port-note: A read of `textPtr`, a local the draft left as a hole.
    // Raven wrote: height = DC->textHeight(textPtr, item->textscale, item->iMenuFont)
    portMissing("Item_Text_AutoWrapped_Paint", source: "oracle/codemp/ui/ui_shared.c:4828")

    y = item.textaligny
    len = 0
    buff[0] = 0
    newLine = 0
    newLineWidth = 0
    // Port-note: A store into `p`, a local the draft left as a hole.
    // Raven wrote: p = textPtr
    portMissing("Item_Text_AutoWrapped_Paint", source: "oracle/codemp/ui/ui_shared.c:4828")
    // Port-note: A read of `p`, a local the draft left as a hole.
    // Raven wrote: while (p) { //findmeste (this will break widechar languages)! if (*p == ' ' || *p == '\t' || *p == '\n' || *p == '\0') { newLine = len; newLinePtr = p+1; newLineWidth = textWidth; } textWidth = DC->textWidth(buff, item->textscale, 0); if ( (newLine && textWidth > item->window.rect.w) || *p == '\n' || *p == '\0') { if (len) { if (item->textalignment == ITEM_ALIGN_LEFT) { item->textRect.x = item->textalignx; } else if (item->textalignment == ITEM_ALIGN_RIGHT) { item->textRect.x = item->textalignx - newLineWidth; } else if (item->textalignment == ITEM_ALIGN_CENTER) { item->textRect.x = item->textalignx - newLineWidth / 2; } item->textRect.y = y; ToWindowCoords(&item->textRect.x, &item->textRect.y, &item->window); // buff[newLine] = '\0'; DC->drawText(item->textRect.x, item->textRect.y, item->textscale, color, buff, 0, 0, item->textStyle, item->iMenuFont); } if (*p == '\0') { break; } // y += height + 5; p = newLinePtr; len = 0; newLine = 0; newLineWidth = 0; continue; } buff[len++] = *p++; buff[len] = '\0'; }
    portMissing("Item_Text_AutoWrapped_Paint", source: "oracle/codemp/ui/ui_shared.c:4828")
}

/// Source: oracle/codemp/ui/ui_shared.c:4911
func Item_Text_Wrapped_Paint(_ item: ItemDef) {
    var text = CharBuf(1024)
    // Port-note: A pointer local `const char * p` with no view.
    // Raven wrote: const char *p;
    portMissing("Item_Text_Wrapped_Paint", source: "oracle/codemp/ui/ui_shared.c:4911")
    // Port-note: A pointer local `const char * start` with no view.
    // Raven wrote: start;
    portMissing("Item_Text_Wrapped_Paint", source: "oracle/codemp/ui/ui_shared.c:4911")
    // Port-note: A pointer local `const char * textPtr` with no view.
    // Raven wrote: textPtr;
    portMissing("Item_Text_Wrapped_Paint", source: "oracle/codemp/ui/ui_shared.c:4911")
    var buff = CharBuf(1024)
    var width: Int32 = 0
    var height: Int32 = 0
    let x: Float
    var y: Float
    var color = vec4_t()

    // now paint the text and/or any optional images
    // default to left

    if item.text == nil {
        if item.cvar == nil {
            return
        } else {
            // Port-note: Raven passes the buffer `text` to the engine as a handle, and the trap takes an OpaquePointer.
            // Raven wrote: DC->getCVarString(item->cvar, text, sizeof(text))
            portMissing("Item_Text_Wrapped_Paint", source: "oracle/codemp/ui/ui_shared.c:4911")
            // Port-note: A store into `textPtr`, a local the draft left as a hole.
            // Raven wrote: textPtr = text
            portMissing("Item_Text_Wrapped_Paint", source: "oracle/codemp/ui/ui_shared.c:4911")
        }
    } else {
        // Port-note: A store into `textPtr`, a local the draft left as a hole.
        // Raven wrote: textPtr = item->text
        portMissing("Item_Text_Wrapped_Paint", source: "oracle/codemp/ui/ui_shared.c:4911")
    }
    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: if (*textPtr == '@') // string reference { trap_SP_GetStringTextString( &textPtr[1], text, sizeof(text)); textPtr = text; }
    portMissing("Item_Text_Wrapped_Paint", source: "oracle/codemp/ui/ui_shared.c:4911")
    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: if (*textPtr == '\0') { return; }
    portMissing("Item_Text_Wrapped_Paint", source: "oracle/codemp/ui/ui_shared.c:4911")

    Item_TextColor(item, &color)
    // Port-note: A read of `textPtr`, a local the draft left as a hole.
    // Raven wrote: Item_SetTextExtents(item, &width, &height, textPtr)
    portMissing("Item_Text_Wrapped_Paint", source: "oracle/codemp/ui/ui_shared.c:4911")

    x = item.textRect.x
    y = item.textRect.y
    // Port-note: A store into `start`, a local the draft left as a hole.
    // Raven wrote: start = textPtr
    portMissing("Item_Text_Wrapped_Paint", source: "oracle/codemp/ui/ui_shared.c:4911")
    // Port-note: A store into `p`, a local the draft left as a hole.
    // Raven wrote: p = strchr(textPtr, '\r')
    portMissing("Item_Text_Wrapped_Paint", source: "oracle/codemp/ui/ui_shared.c:4911")
    // Port-note: A read of `p`, a local the draft left as a hole.
    // Raven wrote: while (p && *p) { strncpy(buff, start, p-start+1); buff[p-start] = '\0'; DC->drawText(x, y, item->textscale, color, buff, 0, 0, item->textStyle, item->iMenuFont); y += height + 2; start += p - start + 1; p = strchr(p+1, '\r'); }
    portMissing("Item_Text_Wrapped_Paint", source: "oracle/codemp/ui/ui_shared.c:4911")
    // Port-note: A read of `start`, a local the draft left as a hole.
    // Raven wrote: DC->drawText(x, y, item->textscale, color, start, 0, 0, item->textStyle, item->iMenuFont)
    portMissing("Item_Text_Wrapped_Paint", source: "oracle/codemp/ui/ui_shared.c:4911")
}

/// Source: oracle/codemp/ui/ui_shared.c:4961
func Item_Text_Paint(_ item: ItemDef) {
    var text = CharBuf(1024)
    // Port-note: A pointer local `const char * textPtr` with no view.
    // Raven wrote: const char *textPtr;
    portMissing("Item_Text_Paint", source: "oracle/codemp/ui/ui_shared.c:4961")
    var height: Int32 = 0
    var width: Int32 = 0
    var color = vec4_t()

    if (item.window.flags & WINDOW_WRAPPED) != 0 {
        Item_Text_Wrapped_Paint(item)
        return
    }
    if (item.window.flags & WINDOW_AUTOWRAPPED) != 0 {
        Item_Text_AutoWrapped_Paint(item)
        return
    }

    if item.text == nil {
        if item.cvar == nil {
            return
        } else {
            // Port-note: Raven passes the buffer `text` to the engine as a handle, and the trap takes an OpaquePointer.
            // Raven wrote: DC->getCVarString(item->cvar, text, sizeof(text))
            portMissing("Item_Text_Paint", source: "oracle/codemp/ui/ui_shared.c:4961")
            // Port-note: A store into `textPtr`, a local the draft left as a hole.
            // Raven wrote: textPtr = text
            portMissing("Item_Text_Paint", source: "oracle/codemp/ui/ui_shared.c:4961")
        }
    } else {
        // Port-note: A store into `textPtr`, a local the draft left as a hole.
        // Raven wrote: textPtr = item->text
        portMissing("Item_Text_Paint", source: "oracle/codemp/ui/ui_shared.c:4961")
    }
    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: if (*textPtr == '@') // string reference { trap_SP_GetStringTextString( &textPtr[1], text, sizeof(text)); textPtr = text; }
    portMissing("Item_Text_Paint", source: "oracle/codemp/ui/ui_shared.c:4961")

    // this needs to go here as it sets extents for cvar types as well
    // Port-note: A read of `textPtr`, a local the draft left as a hole.
    // Raven wrote: Item_SetTextExtents(item, &width, &height, textPtr)
    portMissing("Item_Text_Paint", source: "oracle/codemp/ui/ui_shared.c:4961")

    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: if (*textPtr == '\0') { return; }
    portMissing("Item_Text_Paint", source: "oracle/codemp/ui/ui_shared.c:4961")


    Item_TextColor(item, &color)

    // Port-note: A read of `textPtr`, a local the draft left as a hole.
    // Raven wrote: DC->drawText(item->textRect.x, item->textRect.y, item->textscale, color, textPtr, 0, 0, item->textStyle, item->iMenuFont)
    portMissing("Item_Text_Paint", source: "oracle/codemp/ui/ui_shared.c:4961")

    if item.text2 != nil {
        // Port-note: A store into `textPtr`, a local the draft left as a hole.
        // Raven wrote: textPtr = item->text2
        portMissing("Item_Text_Paint", source: "oracle/codemp/ui/ui_shared.c:4961")
        // Port-note: A pointer dereference the draft cannot place.
        // Raven wrote: if (*textPtr == '@') // string reference { trap_SP_GetStringTextString( &textPtr[1], text, sizeof(text)); textPtr = text; }
        portMissing("Item_Text_Paint", source: "oracle/codemp/ui/ui_shared.c:4961")
        Item_TextColor(item, &color)
        // Port-note: A read of `textPtr`, a local the draft left as a hole.
        // Raven wrote: DC->drawText(item->textRect.x + item->text2alignx, item->textRect.y + item->text2aligny, item->textscale, color, textPtr, 0, 0, item->textStyle,item->iMenuFont)
        portMissing("Item_Text_Paint", source: "oracle/codemp/ui/ui_shared.c:4961")
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:5024
func Item_TextField_Paint(_ item: ItemDef) {
    var buff = CharBuf(1024)
    var newColor = vec4_t()
    var lowLight = vec4_t()
    let offset: Int32
    // Port-note: The draft of this statement did not compile, and the compiler wrote "missing argument label 'handle:' in call".
    // Raven wrote: menuDef_t *parent = (menuDef_t*)item->parent;
    portMissing("Item_TextField_Paint", source: "oracle/codemp/ui/ui_shared.c:5024")
    // Port-note: A pointer local `editFieldDef_t * editPtr` with no view.
    // Raven wrote: editFieldDef_t *editPtr = (editFieldDef_t*)item->typeData;
    portMissing("Item_TextField_Paint", source: "oracle/codemp/ui/ui_shared.c:5024")

    Item_Text_Paint(item)

    buff[0] = 0

    if item.cvar != nil {
        // Port-note: Raven passes the buffer `buff` to the engine as a handle, and the trap takes an OpaquePointer.
        // Raven wrote: DC->getCVarString(item->cvar, buff, sizeof(buff))
        portMissing("Item_TextField_Paint", source: "oracle/codemp/ui/ui_shared.c:5024")
        if buff[0] == Int32(ascii: "@") {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Int8' to expected argument type 'String'".
            // Raven wrote: trap_SP_GetStringTextString( &buff[1], buff, sizeof(buff))
            portMissing("Item_TextField_Paint", source: "oracle/codemp/ui/ui_shared.c:5024")
        }
    }

    // Port-note: The draft of this statement did not compile, and the compiler wrote "missing argument label 'handle:' in call".
    // Raven wrote: parent = (menuDef_t*)item->parent
    portMissing("Item_TextField_Paint", source: "oracle/codemp/ui/ui_shared.c:5024")

    if (item.window.flags & WINDOW_HASFOCUS) != 0 {
        // Port-note: A read of `parent`, a local the draft left as a hole.
        // Raven wrote: lowLight[0] = 0.8 * parent->focusColor[0]
        portMissing("Item_TextField_Paint", source: "oracle/codemp/ui/ui_shared.c:5024")
        // Port-note: A read of `parent`, a local the draft left as a hole.
        // Raven wrote: lowLight[1] = 0.8 * parent->focusColor[1]
        portMissing("Item_TextField_Paint", source: "oracle/codemp/ui/ui_shared.c:5024")
        // Port-note: A read of `parent`, a local the draft left as a hole.
        // Raven wrote: lowLight[2] = 0.8 * parent->focusColor[2]
        portMissing("Item_TextField_Paint", source: "oracle/codemp/ui/ui_shared.c:5024")
        // Port-note: A read of `parent`, a local the draft left as a hole.
        // Raven wrote: lowLight[3] = 0.8 * parent->focusColor[3]
        portMissing("Item_TextField_Paint", source: "oracle/codemp/ui/ui_shared.c:5024")
        // Port-note: A read of `parent`, a local the draft left as a hole.
        // Raven wrote: LerpColor(parent->focusColor,lowLight,newColor,0.5+0.5*sin((float)(DC->realTime / PULSE_DIVISOR)))
        portMissing("Item_TextField_Paint", source: "oracle/codemp/ui/ui_shared.c:5024")
    } else {
        newColor = vec4_t(item.window.foreColor[0], item.window.foreColor[1], item.window.foreColor[2], item.window.foreColor[3])
    }

    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: offset = (item->text && *item->text) ? 8 : 0
    portMissing("Item_TextField_Paint", source: "oracle/codemp/ui/ui_shared.c:5024")
    if (item.window.flags & WINDOW_HASFOCUS) != 0 && g_editingField {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Int32' to specified type 'CChar' (aka 'Int8')".
        // Raven wrote: char cursor = DC->getOverstrikeMode() ? '_' : '|';
        portMissing("Item_TextField_Paint", source: "oracle/codemp/ui/ui_shared.c:5024")
        // Port-note: A read of `editPtr`, a local the draft left as a hole.
        // Raven wrote: DC->drawTextWithCursor(item->textRect.x + item->textRect.w + offset, item->textRect.y, item->textscale, newColor, buff + editPtr->paintOffset, item->cursorPos - editPtr->paintOffset , cursor, item->window.rect.w, item->textStyle, item->iMenuFont)
        portMissing("Item_TextField_Paint", source: "oracle/codemp/ui/ui_shared.c:5024")
    } else {
        // Port-note: A read of `editPtr`, a local the draft left as a hole.
        // Raven wrote: DC->drawText(item->textRect.x + item->textRect.w + offset, item->textRect.y, item->textscale, newColor, buff + editPtr->paintOffset, 0, item->window.rect.w, item->textStyle,item->iMenuFont)
        portMissing("Item_TextField_Paint", source: "oracle/codemp/ui/ui_shared.c:5024")
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:5064
func Item_YesNo_Paint(_ item: ItemDef) {
    var sYES = CharBuf(20)
    var sNO = CharBuf(20)
    var newColor = vec4_t()
    var lowLight = vec4_t()
    let value: Float
    // Port-note: The draft of this statement did not compile, and the compiler wrote "missing argument label 'handle:' in call".
    // Raven wrote: menuDef_t *parent = (menuDef_t*)item->parent;
    portMissing("Item_YesNo_Paint", source: "oracle/codemp/ui/ui_shared.c:5064")
    // Port-note: A pointer local `const char * yesnovalue` with no view.
    // Raven wrote: const char *yesnovalue;
    portMissing("Item_YesNo_Paint", source: "oracle/codemp/ui/ui_shared.c:5064")

    value = item.cvar != nil ? DC!.runGetCVarValue(item.cvar!) : 0

    if (item.window.flags & WINDOW_HASFOCUS) != 0 {
        // Port-note: A read of `parent`, a local the draft left as a hole.
        // Raven wrote: lowLight[0] = 0.8 * parent->focusColor[0]
        portMissing("Item_YesNo_Paint", source: "oracle/codemp/ui/ui_shared.c:5064")
        // Port-note: A read of `parent`, a local the draft left as a hole.
        // Raven wrote: lowLight[1] = 0.8 * parent->focusColor[1]
        portMissing("Item_YesNo_Paint", source: "oracle/codemp/ui/ui_shared.c:5064")
        // Port-note: A read of `parent`, a local the draft left as a hole.
        // Raven wrote: lowLight[2] = 0.8 * parent->focusColor[2]
        portMissing("Item_YesNo_Paint", source: "oracle/codemp/ui/ui_shared.c:5064")
        // Port-note: A read of `parent`, a local the draft left as a hole.
        // Raven wrote: lowLight[3] = 0.8 * parent->focusColor[3]
        portMissing("Item_YesNo_Paint", source: "oracle/codemp/ui/ui_shared.c:5064")
        // Port-note: A read of `parent`, a local the draft left as a hole.
        // Raven wrote: LerpColor(parent->focusColor,lowLight,newColor,0.5+0.5*sin((float)(DC->realTime / PULSE_DIVISOR)))
        portMissing("Item_YesNo_Paint", source: "oracle/codemp/ui/ui_shared.c:5064")
    } else {
        newColor = vec4_t(item.window.foreColor[0], item.window.foreColor[1], item.window.foreColor[2], item.window.foreColor[3])
    }


    strcpy(&sYES, trap_SP_GetStringTextString("MENUS_YES", Int32((sYES).count)).1)
    strcpy(&sNO, trap_SP_GetStringTextString("MENUS_NO", Int32((sNO).count)).1)

    //JLFYESNO MPMOVED
    if item.invertYesNo != 0 {
        // Port-note: A store into `yesnovalue`, a local the draft left as a hole.
        // Raven wrote: yesnovalue = (value == 0) ? sYES : sNO
        portMissing("Item_YesNo_Paint", source: "oracle/codemp/ui/ui_shared.c:5064")
    } else {
        // Port-note: A store into `yesnovalue`, a local the draft left as a hole.
        // Raven wrote: yesnovalue = (value != 0) ? sYES : sNO
        portMissing("Item_YesNo_Paint", source: "oracle/codemp/ui/ui_shared.c:5064")
    }

    if item.text != nil {
        Item_Text_Paint(item)
        //JLF MPMOVED
        // Port-note: A read of `yesnovalue`, a local the draft left as a hole.
        // Raven wrote: DC->drawText(item->textRect.x + item->textRect.w + 8, item->textRect.y, item->textscale, newColor, yesnovalue, 0, 0, item->textStyle, item->iMenuFont)
        portMissing("Item_YesNo_Paint", source: "oracle/codemp/ui/ui_shared.c:5064")
    } else {
        //JLF MPMOVED
        // Port-note: A read of `yesnovalue`, a local the draft left as a hole.
        // Raven wrote: DC->drawText(item->textRect.x, item->textRect.y, item->textscale, newColor, yesnovalue , 0, 0, item->textStyle, item->iMenuFont)
        portMissing("Item_YesNo_Paint", source: "oracle/codemp/ui/ui_shared.c:5064")
    }

    /* JLF ORIGINAL CODE
    if (item->text) {
    Item_Text_Paint(item);
    //		DC->drawText(item->textRect.x + item->textRect.w + 8, item->textRect.y, item->textscale, newColor, (value != 0) ? sYES : sNO, 0, 0, item->textStyle);
    DC->drawText(item->textRect.x + item->textRect.w + 8, item->textRect.y, item->textscale, newColor, (value != 0) ? sYES : sNO, 0, 0, item->textStyle,item->iMenuFont);
    } else {
    //		DC->drawText(item->textRect.x, item->textRect.y, item->textscale, newColor, (value != 0) ? sYES : sNO, 0, 0, item->textStyle);
    DC->drawText(item->textRect.x, item->textRect.y, item->textscale, newColor, (value != 0) ? sYES : sNO, 0, 0, item->textStyle,item->iMenuFont);
    }
    */
}

/// Source: oracle/codemp/ui/ui_shared.c:5128
func Item_Multi_Paint(_ item: ItemDef) {
    var newColor = vec4_t()
    var lowLight = vec4_t()
    var text: String = ""
    // Port-note: The draft of this statement did not compile, and the compiler wrote "missing argument label 'handle:' in call".
    // Raven wrote: menuDef_t *parent = (menuDef_t*)item->parent;
    portMissing("Item_Multi_Paint", source: "oracle/codemp/ui/ui_shared.c:5128")
    var temp = CharBuf(1024)

    if (item.window.flags & WINDOW_HASFOCUS) != 0 {
        // Port-note: A read of `parent`, a local the draft left as a hole.
        // Raven wrote: lowLight[0] = 0.8 * parent->focusColor[0]
        portMissing("Item_Multi_Paint", source: "oracle/codemp/ui/ui_shared.c:5128")
        // Port-note: A read of `parent`, a local the draft left as a hole.
        // Raven wrote: lowLight[1] = 0.8 * parent->focusColor[1]
        portMissing("Item_Multi_Paint", source: "oracle/codemp/ui/ui_shared.c:5128")
        // Port-note: A read of `parent`, a local the draft left as a hole.
        // Raven wrote: lowLight[2] = 0.8 * parent->focusColor[2]
        portMissing("Item_Multi_Paint", source: "oracle/codemp/ui/ui_shared.c:5128")
        // Port-note: A read of `parent`, a local the draft left as a hole.
        // Raven wrote: lowLight[3] = 0.8 * parent->focusColor[3]
        portMissing("Item_Multi_Paint", source: "oracle/codemp/ui/ui_shared.c:5128")
        // Port-note: A read of `parent`, a local the draft left as a hole.
        // Raven wrote: LerpColor(parent->focusColor,lowLight,newColor,0.5+0.5*sin((float)(DC->realTime / PULSE_DIVISOR)))
        portMissing("Item_Multi_Paint", source: "oracle/codemp/ui/ui_shared.c:5128")
    } else {
        newColor = vec4_t(item.window.foreColor[0], item.window.foreColor[1], item.window.foreColor[2], item.window.foreColor[3])
    }

    text = Item_Multi_Setting(item)
    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: if (*text == '@') // string reference { trap_SP_GetStringTextString( &text[1] , temp, sizeof(temp)); text = temp; } // Is is specifying a cvar to get the item name from? else if (*text == '*') { DC->getCVarString(&text[1], temp, sizeof(temp)); text = temp; }
    portMissing("Item_Multi_Paint", source: "oracle/codemp/ui/ui_shared.c:5128")

    if item.text != nil {
        Item_Text_Paint(item)
        //JLF  MPMOVED
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot force unwrap value of non-optional type 'String'".
        // Raven wrote: DC->drawText(item->textRect.x + item->textRect.w + 8, item->textRect.y, item->textscale, newColor, text, 0, 0, item->textStyle,item->iMenuFont)
        portMissing("Item_Multi_Paint", source: "oracle/codemp/ui/ui_shared.c:5128")
    } else {
        //JLF added xoffset
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot force unwrap value of non-optional type 'String'".
        // Raven wrote: DC->drawText(item->textRect.x+item->xoffset, item->textRect.y, item->textscale, newColor, text, 0, 0, item->textStyle,item->iMenuFont)
        portMissing("Item_Multi_Paint", source: "oracle/codemp/ui/ui_shared.c:5128")
    }
}

/**
```
=================
Controls_GetKeyAssignment
=================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:5302
private func Controls_GetKeyAssignment(_ command: String, _ twokeys: inout Int32) {
    var count: Int32
    var j: Int32
    var b = CharBuf(256)

    // Port-note: The draft of this statement did not compile, and the compiler wrote "value of type 'Int32' has no subscripts".
    // Raven wrote: twokeys[0] = twokeys[1] = -1
    portMissing("Controls_GetKeyAssignment", source: "oracle/codemp/ui/ui_shared.c:5302")
    count = 0

    j = 0
    while j < MAX_KEYS {
        // Port-note: Raven passes the buffer `b` to the engine as a handle, and the trap takes an OpaquePointer.
        // Raven wrote: DC->getBindingBuf( j, b, 256 )
        portMissing("Controls_GetKeyAssignment", source: "oracle/codemp/ui/ui_shared.c:5302")
        // Port-note: A pointer dereference the draft cannot place.
        // Raven wrote: if ( *b == 0 ) { continue; }
        portMissing("Controls_GetKeyAssignment", source: "oracle/codemp/ui/ui_shared.c:5302")
        if Q_stricmp(String(b), command) == 0 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "value of type 'Int32' has no subscripts".
            // Raven wrote: twokeys[count] = j
            portMissing("Controls_GetKeyAssignment", source: "oracle/codemp/ui/ui_shared.c:5302")
            count += 1
            if count == 2 {
                break
            }
        }
        j += 1
    }
}

/**
```
=================
Controls_GetConfig
=================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:5332
func Controls_GetConfig() {
    var i: Int32
    var twokeys: [Int32] = [Int32](repeating: 0, count: 2)

    // iterate each command, get its numeric binding
    i = 0
    while i < g_bindCount {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type '[Int32]' to expected argument type 'Int32'".
        // Raven wrote: Controls_GetKeyAssignment(g_bindings[i].command, twokeys)
        portMissing("Controls_GetConfig", source: "oracle/codemp/ui/ui_shared.c:5332")

        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'g_bindings' in scope".
        // Raven wrote: g_bindings[i].bind1 = twokeys[0]
        portMissing("Controls_GetConfig", source: "oracle/codemp/ui/ui_shared.c:5332")
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'g_bindings' in scope".
        // Raven wrote: g_bindings[i].bind2 = twokeys[1]
        portMissing("Controls_GetConfig", source: "oracle/codemp/ui/ui_shared.c:5332")
        i += 1
    }

    //s_controls.invertmouse.curvalue  = DC->getCVarValue( "m_pitch" ) < 0;
    //s_controls.smoothmouse.curvalue  = UI_ClampCvar( 0, 1, Controls_GetCvarValue( "m_filter" ) );
    //s_controls.alwaysrun.curvalue    = UI_ClampCvar( 0, 1, Controls_GetCvarValue( "cl_run" ) );
    //s_controls.autoswitch.curvalue   = UI_ClampCvar( 0, 1, Controls_GetCvarValue( "cg_autoswitch" ) );
    //s_controls.sensitivity.curvalue  = UI_ClampCvar( 2, 30, Controls_GetCvarValue( "sensitivity" ) );
    //s_controls.joyenable.curvalue    = UI_ClampCvar( 0, 1, Controls_GetCvarValue( "in_joystick" ) );
    //s_controls.joythreshold.curvalue = UI_ClampCvar( 0.05, 0.75, Controls_GetCvarValue( "joy_threshold" ) );
    //s_controls.freelook.curvalue     = UI_ClampCvar( 0, 1, Controls_GetCvarValue( "cl_freelook" ) );
}

/**
```
=================
Controls_SetConfig
=================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:5362
func Controls_SetConfig(_ restart: Bool) {
    var i: Int32

    // iterate each command, get its numeric binding
    i = 0
    while i < g_bindCount {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'g_bindings' in scope".
        // Raven wrote: if (g_bindings[i].bind1 != -1) { DC->setBinding( g_bindings[i].bind1, g_bindings[i].command ); if (g_bindings[i].bind2 != -1) DC->setBinding( g_bindings[i].bind2, g_bindings[i].command ); }
        portMissing("Controls_SetConfig", source: "oracle/codemp/ui/ui_shared.c:5362")
        i += 1
    }

    //if ( s_controls.invertmouse.curvalue )
    //	DC->setCVar("m_pitch", va("%f),-fabs( DC->getCVarValue( "m_pitch" ) ) );
    //else
    //	trap_Cvar_SetValue( "m_pitch", fabs( trap_Cvar_VariableValue( "m_pitch" ) ) );

    //trap_Cvar_SetValue( "m_filter", s_controls.smoothmouse.curvalue );
    //trap_Cvar_SetValue( "cl_run", s_controls.alwaysrun.curvalue );
    //trap_Cvar_SetValue( "cg_autoswitch", s_controls.autoswitch.curvalue );
    //trap_Cvar_SetValue( "sensitivity", s_controls.sensitivity.curvalue );
    //trap_Cvar_SetValue( "in_joystick", s_controls.joyenable.curvalue );
    //trap_Cvar_SetValue( "joy_threshold", s_controls.joythreshold.curvalue );
    //trap_Cvar_SetValue( "cl_freelook", s_controls.freelook.curvalue );
    //
    //	DC->executeText(EXEC_APPEND, "in_restart\n");
    // ^--this is bad, it shows the cursor during map load, if you need to, add it as an exec cmd to use_joy or something.
}

/// Source: oracle/codemp/ui/ui_shared.c:5396
func BindingIDFromName(_ name: String) -> Int32 {
    var i: Int32
    i = 0
    while i < g_bindCount {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'g_bindings' in scope".
        // Raven wrote: if (Q_stricmp(name, g_bindings[i].command) == 0) { return i; }
        portMissing("BindingIDFromName", source: "oracle/codemp/ui/ui_shared.c:5396")
        i += 1
    }
    return -1
}

/// Source: oracle/codemp/ui/ui_shared.c:5410
func BindingFromName(_ cvar: String) {
    var i: Int32
    var b1: Int32
    var b2: Int32
    var sOR = CharBuf(32)


    // iterate each command, set its default binding
    i = 0
    while i < g_bindCount {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'g_bindings' in scope".
        // Raven wrote: if (Q_stricmp(cvar, g_bindings[i].command) == 0) { b1 = g_bindings[i].bind1; if (b1 == -1) { break; } DC->keynumToStringBuf( b1, g_nameBind1, 32 ); // do NOT do this or it corrupts asian text!!! Q_strupr(g_nameBind1); b2 = g_bindings[i].bind2; if (b2 != -1) { DC->keynumToStringBuf( b2, g_nameBind2, 32 ); // do NOT do this or it corrupts asian text!!! Q_strupr(g_nameBind2); trap_SP_GetStringTextString("MENUS_KEYBIND_OR",sOR, sizeof(sOR)); strcat( g_nameBind1, va(" %s ",sOR)); strcat( g_nameBind1, g_nameBind2 ); } return; }
        portMissing("BindingFromName", source: "oracle/codemp/ui/ui_shared.c:5410")
        i += 1
    }
    strcpy(&g_nameBind1, "???")
}

/// Source: oracle/codemp/ui/ui_shared.c:5443
func Item_Slider_Paint(_ item: ItemDef) {
    var newColor = vec4_t()
    var lowLight = vec4_t()
    var x: Float
    let y: Float
    let value: Float
    // Port-note: The draft of this statement did not compile, and the compiler wrote "missing argument label 'handle:' in call".
    // Raven wrote: menuDef_t *parent = (menuDef_t*)item->parent;
    portMissing("Item_Slider_Paint", source: "oracle/codemp/ui/ui_shared.c:5443")

    value = item.cvar != nil ? DC!.runGetCVarValue(item.cvar!) : 0

    if (item.window.flags & WINDOW_HASFOCUS) != 0 {
        // Port-note: A read of `parent`, a local the draft left as a hole.
        // Raven wrote: lowLight[0] = 0.8 * parent->focusColor[0]
        portMissing("Item_Slider_Paint", source: "oracle/codemp/ui/ui_shared.c:5443")
        // Port-note: A read of `parent`, a local the draft left as a hole.
        // Raven wrote: lowLight[1] = 0.8 * parent->focusColor[1]
        portMissing("Item_Slider_Paint", source: "oracle/codemp/ui/ui_shared.c:5443")
        // Port-note: A read of `parent`, a local the draft left as a hole.
        // Raven wrote: lowLight[2] = 0.8 * parent->focusColor[2]
        portMissing("Item_Slider_Paint", source: "oracle/codemp/ui/ui_shared.c:5443")
        // Port-note: A read of `parent`, a local the draft left as a hole.
        // Raven wrote: lowLight[3] = 0.8 * parent->focusColor[3]
        portMissing("Item_Slider_Paint", source: "oracle/codemp/ui/ui_shared.c:5443")
        // Port-note: A read of `parent`, a local the draft left as a hole.
        // Raven wrote: LerpColor(parent->focusColor,lowLight,newColor,0.5+0.5*sin((float)(DC->realTime / PULSE_DIVISOR)))
        portMissing("Item_Slider_Paint", source: "oracle/codemp/ui/ui_shared.c:5443")
    } else {
        newColor = vec4_t(item.window.foreColor[0], item.window.foreColor[1], item.window.foreColor[2], item.window.foreColor[3])
    }

    y = item.window.rect.y
    if item.text != nil {
        Item_Text_Paint(item)
        x = item.textRect.x + item.textRect.w + 8
    } else {
        x = item.window.rect.x
    }
    DC!.runSetColor(newColor)
    DC!.runDrawHandlePic(x, y, Float(SLIDER_WIDTH), Float(SLIDER_HEIGHT), DC!.Assets.sliderBar)

    x = Item_Slider_ThumbPosition(item)
    DC!.runDrawHandlePic(Float(Double(x) - (SLIDER_THUMB_WIDTH / 2)), y - 2, Float(SLIDER_THUMB_WIDTH), Float(SLIDER_THUMB_HEIGHT), DC!.Assets.sliderThumb)
}

/// Source: oracle/codemp/ui/ui_shared.c:5475
func Item_Bind_Paint(_ item: ItemDef) {
    var newColor = vec4_t()
    var lowLight = vec4_t()
    let value: Float
    var maxChars: Int32 = 0
    var textScale: Float
    var textWidth: Float
    let textHeight: Int32
    var yAdj: Int32
    let startingXPos: Int32


    // Port-note: The draft of this statement did not compile, and the compiler wrote "missing argument label 'handle:' in call".
    // Raven wrote: menuDef_t *parent = (menuDef_t*)item->parent;
    portMissing("Item_Bind_Paint", source: "oracle/codemp/ui/ui_shared.c:5475")
    // Port-note: A pointer local `editFieldDef_t * editPtr` with no view.
    // Raven wrote: editFieldDef_t *editPtr = (editFieldDef_t*)item->typeData;
    portMissing("Item_Bind_Paint", source: "oracle/codemp/ui/ui_shared.c:5475")
    // Port-note: A read of `editPtr`, a local the draft left as a hole.
    // Raven wrote: if (editPtr) { maxChars = editPtr->maxPaintChars; }
    portMissing("Item_Bind_Paint", source: "oracle/codemp/ui/ui_shared.c:5475")

    value = item.cvar != nil ? DC!.runGetCVarValue(item.cvar!) : 0

    if (item.window.flags & WINDOW_HASFOCUS) != 0 {
        if g_bindItem == item {
            lowLight[0] = 0.8 * 1.0
            lowLight[1] = 0.8 * 0.0
            lowLight[2] = 0.8 * 0.0
            lowLight[3] = 0.8 * 1.0
        } else {
            // Port-note: A read of `parent`, a local the draft left as a hole.
            // Raven wrote: lowLight[0] = 0.8f * parent->focusColor[0]
            portMissing("Item_Bind_Paint", source: "oracle/codemp/ui/ui_shared.c:5475")
            // Port-note: A read of `parent`, a local the draft left as a hole.
            // Raven wrote: lowLight[1] = 0.8f * parent->focusColor[1]
            portMissing("Item_Bind_Paint", source: "oracle/codemp/ui/ui_shared.c:5475")
            // Port-note: A read of `parent`, a local the draft left as a hole.
            // Raven wrote: lowLight[2] = 0.8f * parent->focusColor[2]
            portMissing("Item_Bind_Paint", source: "oracle/codemp/ui/ui_shared.c:5475")
            // Port-note: A read of `parent`, a local the draft left as a hole.
            // Raven wrote: lowLight[3] = 0.8f * parent->focusColor[3]
            portMissing("Item_Bind_Paint", source: "oracle/codemp/ui/ui_shared.c:5475")
        }
        // Port-note: A read of `parent`, a local the draft left as a hole.
        // Raven wrote: LerpColor(parent->focusColor,lowLight,newColor,0.5+0.5*sin((float)(DC->realTime / PULSE_DIVISOR)))
        portMissing("Item_Bind_Paint", source: "oracle/codemp/ui/ui_shared.c:5475")
    } else {
        newColor = vec4_t(item.window.foreColor[0], item.window.foreColor[1], item.window.foreColor[2], item.window.foreColor[3])
    }

    if item.text != nil {
        Item_Text_Paint(item)
        BindingFromName(item.cvar!)

        // If the text runs past the limit bring the scale down until it fits.
        textScale = item.textscale
        textWidth = Float(DC!.runTextWidth(String(g_nameBind1), Float(textScale), item.iMenuFont))
        startingXPos = Int32((item.textRect.x + item.textRect.w + 8))

        while (startingXPos + textWidth) >= SCREEN_WIDTH {
            textScale -= 0.05
            textWidth = Float(DC!.runTextWidth(String(g_nameBind1), Float(textScale), item.iMenuFont))
        }

        // Try to adjust it's y placement if the scale has changed.
        yAdj = 0
        if textScale != item.textscale {
            textHeight = DC!.runTextHeight(String(g_nameBind1), item.textscale, item.iMenuFont)
            yAdj = textHeight - DC!.runTextHeight(String(g_nameBind1), textScale, item.iMenuFont)
        }

        DC!.runDrawText(Float(startingXPos), item.textRect.y + yAdj, textScale, &newColor, String(g_nameBind1), 0, maxChars, item.textStyle, item.iMenuFont)
    } else {
        DC!.runDrawText(item.textRect.x, item.textRect.y, item.textscale, &newColor, (value != 0) ? "FIXME" : "FIXME", 0, maxChars, item.textStyle, item.iMenuFont)
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:5548
func Display_KeyBindPending() -> Bool {
    return g_waitingForKey
}

/// Source: oracle/codemp/ui/ui_shared.c:5552
func Item_Bind_HandleKey(_ item: ItemDef, _ key: Int32, _ down: Bool) -> Bool {
    var id: Int32
    var i: Int32

    if key == A_MOUSE1 && Rect_ContainsPoint(item.window.rect, Float(DC!.cursorx), Float(DC!.cursory)) && !g_waitingForKey {
        if down {
            g_waitingForKey = true
            g_bindItem = item
        }
        return true
    } else if key == A_ENTER && !g_waitingForKey {
        if down {
            g_waitingForKey = true
            g_bindItem = item
        }
        return true
    } else {
        if !g_waitingForKey || g_bindItem == nil {
            return false
        }

        if (key & K_CHAR_FLAG) != 0 {
            return true
        }

        switch key {
        case A_ESCAPE:
            g_waitingForKey = false
            return true

        case A_BACKSPACE:
            id = BindingIDFromName(item.cvar!)
            if id != -1 {
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'g_bindings' in scope".
                // Raven wrote: if ( g_bindings[id].bind1 != -1 ) { DC->setBinding ( g_bindings[id].bind1, "" ); }
                portMissing("Item_Bind_HandleKey", source: "oracle/codemp/ui/ui_shared.c:5552")

                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'g_bindings' in scope".
                // Raven wrote: if ( g_bindings[id].bind2 != -1 ) { DC->setBinding ( g_bindings[id].bind2, "" ); }
                portMissing("Item_Bind_HandleKey", source: "oracle/codemp/ui/ui_shared.c:5552")

                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'g_bindings' in scope".
                // Raven wrote: g_bindings[id].bind1 = -1
                portMissing("Item_Bind_HandleKey", source: "oracle/codemp/ui/ui_shared.c:5552")
                // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'g_bindings' in scope".
                // Raven wrote: g_bindings[id].bind2 = -1
                portMissing("Item_Bind_HandleKey", source: "oracle/codemp/ui/ui_shared.c:5552")
            }
            Controls_SetConfig(true)
            g_waitingForKey = false
            g_bindItem = nil
            return true

        case Int32(ascii: "`"):
            return true

        default:
            break
        }
    }

    if key != -1 {
        i = 0
        while i < g_bindCount {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'g_bindings' in scope".
            // Raven wrote: if (g_bindings[i].bind2 == key) { g_bindings[i].bind2 = -1; }
            portMissing("Item_Bind_HandleKey", source: "oracle/codemp/ui/ui_shared.c:5552")

            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'g_bindings' in scope".
            // Raven wrote: if (g_bindings[i].bind1 == key) { g_bindings[i].bind1 = g_bindings[i].bind2; g_bindings[i].bind2 = -1; }
            portMissing("Item_Bind_HandleKey", source: "oracle/codemp/ui/ui_shared.c:5552")
            i += 1
        }
    }


    id = BindingIDFromName(item.cvar!)

    if id != -1 {
        if key == -1 {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'g_bindings' in scope".
            // Raven wrote: if( g_bindings[id].bind1 != -1 ) { DC->setBinding( g_bindings[id].bind1, "" ); g_bindings[id].bind1 = -1; }
            portMissing("Item_Bind_HandleKey", source: "oracle/codemp/ui/ui_shared.c:5552")
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'g_bindings' in scope".
            // Raven wrote: if( g_bindings[id].bind2 != -1 ) { DC->setBinding( g_bindings[id].bind2, "" ); g_bindings[id].bind2 = -1; }
            portMissing("Item_Bind_HandleKey", source: "oracle/codemp/ui/ui_shared.c:5552")
        } else {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'g_bindings' in scope".
            // Raven wrote: if (g_bindings[id].bind1 == -1) { g_bindings[id].bind1 = key; } else if (g_bindings[id].bind1 != key && g_bindings[id].bind2 == -1) { g_bindings[id].bind2 = key; } else { DC->setBinding( g_bindings[id].bind1, "" ); DC->setBinding( g_bindings[id].bind2, "" ); g_bindings[id].bind1 = key; g_bindings[id].bind2 = -1; }
            portMissing("Item_Bind_HandleKey", source: "oracle/codemp/ui/ui_shared.c:5552")
        }
    }

    Controls_SetConfig(true)
    g_waitingForKey = false

    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:5668
func UI_ScaleModelAxis(_ ent: JKAMP.RefEntity) {
    // scale the model should we need to
    if ent.modelScale[0] != 0 && ent.modelScale[0] != 1.0 {
        ent.axis[0] = ent.axis[0] * ent.modelScale[0]
        ent.nonNormalizedAxes = true
    }
    if ent.modelScale[1] != 0 && ent.modelScale[1] != 1.0 {
        ent.axis[1] = ent.axis[1] * ent.modelScale[1]
        ent.nonNormalizedAxes = true
    }
    if ent.modelScale[2] != 0 && ent.modelScale[2] != 1.0 {
        ent.axis[2] = ent.axis[2] * ent.modelScale[2]
        ent.nonNormalizedAxes = true
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:5694
func Item_Model_Paint(_ item: ItemDef) {
    var x: Float = 0
    var y: Float = 0
    var w: Float = 0
    var h: Float = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    // The closure gives true where Raven returns from the function.
    let earlyOut = Refdef.scratch { refdef -> Bool in
        // Raven's record lives to the end of his block, so the block is the closure.
        // The closure gives true where Raven returns from the function.
        let earlyOut2 = RefEntity.scratch { ent -> Bool in
            var mins = vec3_t()
            var maxs = vec3_t()
            var origin = vec3_t()
            var angles = vec3_t()
            // Port-note: A pointer local `modelDef_t * modelPtr` with no view.
            // Raven wrote: modelDef_t *modelPtr = (modelDef_t*)item->typeData;
            portMissing("Item_Model_Paint", source: "oracle/codemp/ui/ui_shared.c:5694")

            // Port-note: A read of `modelPtr`, a local the draft left as a hole.
            // Raven wrote: if (modelPtr == NULL) { return; }
            portMissing("Item_Model_Paint", source: "oracle/codemp/ui/ui_shared.c:5694")

            // a moves datapad anim is playing

            //HACKHACKHACK: check for any multi-part anim sequences, and play the next anim, if needbe


            //update saber models

            // setup the refdef
            // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.

            refdef.rdflags = RDF_NOWORLDMODEL
            // Port-note: The draft of this statement did not compile, and the compiler wrote "'&' used with non-inout argument of type 'Slots<vec3_t>' (aka 'Slots<SIMD3<Float>>')".
            // Raven wrote: AxisClear( refdef.viewaxis )
            portMissing("Item_Model_Paint", source: "oracle/codemp/ui/ui_shared.c:5694")
            x = item.window.rect.x + 1
            y = item.window.rect.y + 1
            w = item.window.rect.w - 2
            h = item.window.rect.h - 2

            refdef.x = Int32(x * DC!.xscale)
            refdef.y = Int32(y * DC!.yscale)
            refdef.width = Int32(w * DC!.xscale)
            refdef.height = Int32(h * DC!.yscale)

            if item.ghoul2 != nil {
                //ghoul2 models don't have bounds, so we have to parse them.
                // Port-note: A read of `modelPtr`, a local the draft left as a hole.
                // Raven wrote: VectorCopy(modelPtr->g2mins, mins)
                portMissing("Item_Model_Paint", source: "oracle/codemp/ui/ui_shared.c:5694")
                // Port-note: A read of `modelPtr`, a local the draft left as a hole.
                // Raven wrote: VectorCopy(modelPtr->g2maxs, maxs)
                portMissing("Item_Model_Paint", source: "oracle/codemp/ui/ui_shared.c:5694")

                if mins[0] == 0 && mins[1] == 0 && mins[2] == 0 && maxs[0] == 0 && maxs[1] == 0 && maxs[2] == 0 {
                    //we'll use defaults then I suppose.
                    mins = vec3_t(-16, -16, -24)
                    maxs = vec3_t(16, 16, 32)
                }
            } else {
                DC!.runModelBounds(item.asset, &mins, &maxs)
            }

            origin[2] = Float(-0.5 * Double(mins[2] + maxs[2]))
            origin[1] = Float(0.5 * Double(mins[1] + maxs[1]))

            // calculate distance so the model nearly fills the box
            let len: Float = Float(0.5 * Double(maxs[2] - mins[2]))
            origin[0] = Float(Double(len) / 0.268) // len / tan( fov/2 )
            //origin[0] = len / tan(w/2);
            // Port-note: A read of `modelPtr`, a local the draft left as a hole.
            // Raven wrote: refdef.fov_x = (modelPtr->fov_x) ? modelPtr->fov_x : (int)((float)refdef.width / 640.0f * 90.0f)
            portMissing("Item_Model_Paint", source: "oracle/codemp/ui/ui_shared.c:5694")
            // Port-note: A read of `modelPtr`, a local the draft left as a hole.
            // Raven wrote: refdef.fov_y = (modelPtr->fov_y) ? modelPtr->fov_y : atan2( refdef.height, refdef.width / tan( refdef.fov_x / 360 * M_PI ) ) * ( 360 / M_PI )
            portMissing("Item_Model_Paint", source: "oracle/codemp/ui/ui_shared.c:5694")

            //refdef.fov_x = (int)((float)refdef.width / 640.0f * 90.0f);
            //refdef.fov_y = atan2( refdef.height, refdef.width / tan( refdef.fov_x / 360 * M_PI ) ) * ( 360 / M_PI );

            DC!.runClearScene()

            refdef.time = DC!.realTime

            // add the model

            // Raven clears the record with `memset` here. The scratch slot is zero at entry, so the body drops the call.

            // use item storage to track
            // Port-note: A read of `modelPtr`, a local the draft left as a hole.
            // Raven wrote: if ( (item->flags&ITF_ISANYSABER) && !(item->flags&ITF_ISCHARACTER) ) {//hack to put saber on it's side if (modelPtr->rotationSpeed) { VectorSet( angles, modelPtr->angle+(float)refdef.time/modelPtr->rotationSpeed, 0, 90 ); } else { VectorSet( angles, modelPtr->angle, 0, 90 ); } } else if (modelPtr->rotationSpeed) { VectorSet( angles, 0, modelPtr->angle + (float)refdef.time/modelPtr->rotationSpeed, 0 ); } else { VectorSet( angles, 0, modelPtr->angle, 0 ); }
            portMissing("Item_Model_Paint", source: "oracle/codemp/ui/ui_shared.c:5694")

            // Port-note: The draft of this statement did not compile, and the compiler wrote "'&' used with non-inout argument of type 'Slots<vec3_t>' (aka 'Slots<SIMD3<Float>>')".
            // Raven wrote: AnglesToAxis( angles, ent.axis )
            portMissing("Item_Model_Paint", source: "oracle/codemp/ui/ui_shared.c:5694")

            if item.ghoul2 != nil {
                ent.ghoul2 = item.ghoul2
                ent.radius = 1000
                // Port-note: A read of `modelPtr`, a local the draft left as a hole.
                // Raven wrote: ent.customSkin = modelPtr->g2skin
                portMissing("Item_Model_Paint", source: "oracle/codemp/ui/ui_shared.c:5694")

                // Port-note: A read of `modelPtr`, a local the draft left as a hole.
                // Raven wrote: VectorCopy(modelPtr->g2scale, ent.modelScale)
                portMissing("Item_Model_Paint", source: "oracle/codemp/ui/ui_shared.c:5694")
                UI_ScaleModelAxis(ent)
                //			UI_TalkingHead(item);
            } else {
                ent.hModel = item.asset
            }
            ent.origin = origin
            ent.oldorigin = ent.origin

            // Set up lighting
            ent.lightingOrigin = origin
            ent.renderfx = RF_LIGHTING_ORIGIN | RF_NOSHADOW

            DC!.runAddRefEntityToScene(ent)
            DC!.runRenderScene(refdef)
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

/// Source: oracle/codemp/ui/ui_shared.c:5903
func Item_Image_Paint(_ item: ItemDef) {
    if item == nil {
        return
    }
    DC!.runDrawHandlePic(item.window.rect.x + 1, item.window.rect.y + 1, item.window.rect.w - 2, item.window.rect.h - 2, item.asset)
}

/// Source: oracle/codemp/ui/ui_shared.c:5911
func Item_TextScroll_Paint(_ item: ItemDef) {
    var cvartext = CharBuf(1024)
    var x: Float
    var y: Float
    var size: Float
    let count: Float
    var thumb: Float
    var i: Int32
    // Port-note: A pointer local `textScrollDef_t * scrollPtr` with no view.
    // Raven wrote: textScrollDef_t *scrollPtr = (textScrollDef_t*)item->typeData;
    portMissing("Item_TextScroll_Paint", source: "oracle/codemp/ui/ui_shared.c:5911")

    // Port-note: A read of `scrollPtr`, a local the draft left as a hole.
    // Raven wrote: count = scrollPtr->iLineCount
    portMissing("Item_TextScroll_Paint", source: "oracle/codemp/ui/ui_shared.c:5911")

    // draw scrollbar to right side of the window
    x = Float(Double(item.window.rect.x + item.window.rect.w) - SCROLLBAR_SIZE - 1)
    y = item.window.rect.y + 1
    DC!.runDrawHandlePic(x, y, Float(SCROLLBAR_SIZE), Float(SCROLLBAR_SIZE), DC!.Assets.scrollBarArrowUp)
    y = Float(Double(y) + (SCROLLBAR_SIZE - 1))

    // Port-note: A read of `scrollPtr`, a local the draft left as a hole.
    // Raven wrote: scrollPtr->endPos = scrollPtr->startPos
    portMissing("Item_TextScroll_Paint", source: "oracle/codemp/ui/ui_shared.c:5911")
    size = Float(Double(item.window.rect.h) - (SCROLLBAR_SIZE * 2))
    DC!.runDrawHandlePic(x, y, Float(SCROLLBAR_SIZE), size + 1, DC!.Assets.scrollBar)
    y += size - 1
    DC!.runDrawHandlePic(x, y, Float(SCROLLBAR_SIZE), Float(SCROLLBAR_SIZE), DC!.Assets.scrollBarArrowDown)

    // thumb
    thumb = Float(Item_TextScroll_ThumbDrawPosition(item))
    if Double(thumb) > Double(y) - SCROLLBAR_SIZE - 1 {
        thumb = Float(Double(y) - SCROLLBAR_SIZE - 1)
    }
    DC!.runDrawHandlePic(x, thumb, Float(SCROLLBAR_SIZE), Float(SCROLLBAR_SIZE), DC!.Assets.scrollBarThumb)

    if item.cvar != nil {
        // Port-note: Raven passes the buffer `cvartext` to the engine as a handle, and the trap takes an OpaquePointer.
        // Raven wrote: DC->getCVarString(item->cvar, cvartext, sizeof(cvartext))
        portMissing("Item_TextScroll_Paint", source: "oracle/codemp/ui/ui_shared.c:5911")
        item.text = String(cvartext)
        Item_TextScroll_BuildLines(item)
    }

    // adjust size for item painting
    size = item.window.rect.h - 2
    x = item.window.rect.x + item.textalignx + 1
    y = item.window.rect.y + item.textaligny + 1

    // Port-note: A read of `scrollPtr`, a local the draft left as a hole.
    // Raven wrote: for (i = scrollPtr->startPos; i < count; i++) { const char *text; text = scrollPtr->pLines[i]; if (!text) { continue; } DC->drawText(x + 4, y, item->textscale, item->window.foreColor, text, 0, 0, item->textStyle, item->iMenuFont); size -= scrollPtr->lineHeight; if (size < scrollPtr->lineHeight) { scrollPtr->drawPadding = scrollPtr->lineHeight - size; break; } scrollPtr->endPos++; y += scrollPtr->lineHeight; }
    portMissing("Item_TextScroll_Paint", source: "oracle/codemp/ui/ui_shared.c:5911")
}

// Draw routine for list boxes
/// Source: oracle/codemp/ui/ui_shared.c:5979
func Item_ListBox_Paint(_ item: ItemDef) {
    var x: Float
    var y: Float
    var sizeWidth: Float
    let count: Float
    var i: Float
    var i2: Float
    var sizeHeight: Float
    var thumb: Float
    var startPos: Int32
    var image: qhandle_t
    var optionalImage1: qhandle_t = 0
    var optionalImage2: qhandle_t = 0
    var optionalImage3: qhandle_t = 0
    // Port-note: A pointer local `listBoxDef_t * listPtr` with no view.
    // Raven wrote: listBoxDef_t *listPtr = (listBoxDef_t*)item->typeData;
    portMissing("Item_ListBox_Paint", source: "oracle/codemp/ui/ui_shared.c:5979")
    //JLF MPMOVED
    let numlines: Int32


    // the listbox is horizontal or vertical and has a fixed size scroll bar going either direction
    // elements are enumerated from the DC and either text or image handles are acquired from the DC as well
    // textscale is used to size the text, textalignx and textaligny are used to size image elements
    // there is no clipping available so only the last completely visible item is painted
    count = Float(DC!.runFeederCount(item.special))

    //JLFLISTBOX  MPMOVED
    //item->cursorPos = listPtr->startPos;
    //JLFLISTBOX MPMOVED
    // Port-note: A read of `listPtr`, a local the draft left as a hole.
    // Raven wrote: if (listPtr->startPos > (count?count-1:count)) {//probably changed feeders, so reset listPtr->startPos = 0; }
    portMissing("Item_ListBox_Paint", source: "oracle/codemp/ui/ui_shared.c:5979")
    //JLF END
    if item.cursorPos > (count != 0 ? count - 1 : count) {
        //probably changed feeders, so reset
        item.cursorPos = Int32((count != 0 ? count - 1 : count))
        // NOTE : might consider moving this to any spot in here we change the cursor position
        DC!.runFeederSelection(item.special, item.cursorPos, nil)
    }



    // default is vertical if horizontal flag is not here
    if (item.window.flags & WINDOW_HORIZONTAL) != 0 {
        //JLF new variable (code just indented) MPMOVED
        // Port-note: A read of `listPtr`, a local the draft left as a hole.
        // Raven wrote: if (!listPtr->scrollhidden) { // draw scrollbar in bottom of the window // bar if (Item_ListBox_MaxScroll(item) > 0) { x = item->window.rect.x + 1; y = item->window.rect.y + item->window.rect.h - SCROLLBAR_SIZE - 1; DC->drawHandlePic(x, y, SCROLLBAR_SIZE, SCROLLBAR_SIZE, DC->Assets.scrollBarArrowLeft); x += SCROLLBAR_SIZE - 1; sizeWidth = item->window.rect.w - (SCROLLBAR_SIZE * 2); DC->drawHandlePic(x, y, sizeWidth+1, SCROLLBAR_SIZE, DC->Assets.scrollBar); x += sizeWidth - 1; DC->drawHandlePic(x, y, SCROLLBAR_SIZE, SCROLLBAR_SIZE, DC->Assets.scrollBarArrowRight); // thumb thumb = Item_ListBox_ThumbDrawPosition(item);//Item_ListBox_ThumbPosition(item); if (thumb > x - SCROLLBAR_SIZE - 1) { thumb = x - SCROLLBAR_SIZE - 1; } DC->drawHandlePic(thumb, y, SCROLLBAR_SIZE, SCROLLBAR_SIZE, DC->Assets.scrollBarThumb); } else if (listPtr->startPos > 0) { listPtr->startPos = 0; } }
        portMissing("Item_ListBox_Paint", source: "oracle/codemp/ui/ui_shared.c:5979")
        //JLF end
        //
        // Port-note: A read of `listPtr`, a local the draft left as a hole.
        // Raven wrote: listPtr->endPos = listPtr->startPos
        portMissing("Item_ListBox_Paint", source: "oracle/codemp/ui/ui_shared.c:5979")
        sizeWidth = item.window.rect.w - 2
        // items
        // size contains max available space
        // Port-note: A read of `listPtr`, a local the draft left as a hole.
        // Raven wrote: if (listPtr->elementStyle == LISTBOX_IMAGE) { // fit = 0; x = item->window.rect.x + 1; y = item->window.rect.y + 1; for (i = listPtr->startPos; i < count; i++) { // always draw at least one // which may overdraw the box if it is too small for the element image = DC->feederItemImage(item->special, i); if (image) { #ifndef CGAME if (item->window.flags & WINDOW_PLAYERCOLOR) { vec4_t color; color[0] = ui_char_color_red.integer/COLOR_MAX; color[1] = ui_char_color_green.integer/COLOR_MAX; color[2] = ui_char_color_blue.integer/COLOR_MAX; color[3] = 1.0f; DC->setColor(color); } #endif DC->drawHandlePic(x+1, y+1, listPtr->elementWidth - 2, listPtr->elementHeight - 2, image); } if (i == item->cursorPos) { DC->drawRect(x, y, listPtr->elementWidth-1, listPtr->elementHeight-1, item->window.borderSize, item->window.borderColor); } sizeWidth -= listPtr->elementWidth; if (sizeWidth < listPtr->elementWidth) { listPtr->drawPadding = sizeWidth; //listPtr->elementWidth - size; break; } x += listPtr->elementWidth; listPtr->endPos++; // fit++; } } else { // }
        portMissing("Item_ListBox_Paint", source: "oracle/codemp/ui/ui_shared.c:5979")

        // Show pic name
    } else {
        // A vertical list box
        //JLF MPMOVED
        // Port-note: A read of `listPtr`, a local the draft left as a hole.
        // Raven wrote: numlines = item->window.rect.h / listPtr->elementHeight
        portMissing("Item_ListBox_Paint", source: "oracle/codemp/ui/ui_shared.c:5979")
        //JLFEND
        //JLF new variable (code idented with if)
        // Port-note: A read of `listPtr`, a local the draft left as a hole.
        // Raven wrote: if (!listPtr->scrollhidden) { // draw scrollbar to right side of the window x = item->window.rect.x + item->window.rect.w - SCROLLBAR_SIZE - 1; y = item->window.rect.y + 1; DC->drawHandlePic(x, y, SCROLLBAR_SIZE, SCROLLBAR_SIZE, DC->Assets.scrollBarArrowUp); y += SCROLLBAR_SIZE - 1; listPtr->endPos = listPtr->startPos; sizeHeight = item->window.rect.h - (SCROLLBAR_SIZE * 2); DC->drawHandlePic(x, y, SCROLLBAR_SIZE, sizeHeight+1, DC->Assets.scrollBar); y += sizeHeight - 1; DC->drawHandlePic(x, y, SCROLLBAR_SIZE, SCROLLBAR_SIZE, DC->Assets.scrollBarArrowDown); // thumb thumb = Item_ListBox_ThumbDrawPosition(item);//Item_ListBox_ThumbPosition(item); if (thumb > y - SCROLLBAR_SIZE - 1) { thumb = y - SCROLLBAR_SIZE - 1; } DC->drawHandlePic(x, thumb, SCROLLBAR_SIZE, SCROLLBAR_SIZE, DC->Assets.scrollBarThumb); }
        portMissing("Item_ListBox_Paint", source: "oracle/codemp/ui/ui_shared.c:5979")
        //JLF end

        // adjust size for item painting
        sizeWidth = item.window.rect.w - 2
        sizeHeight = item.window.rect.h - 2

        // Port-note: A read of `listPtr`, a local the draft left as a hole.
        // Raven wrote: if (listPtr->elementStyle == LISTBOX_IMAGE) { // Multiple rows and columns (since it's more than twice as wide as an element) if ( item->window.rect.w > (listPtr->elementWidth*2) ) { startPos = listPtr->startPos; x = item->window.rect.x + 1; y = item->window.rect.y + 1; // Next row for (i2 = startPos; i2 < count; i2++) { x = item->window.rect.x + 1; sizeWidth = item->window.rect.w - 2; // print a row for (i = startPos; i < count; i++) { // always draw at least one // which may overdraw the box if it is too small for the element image = DC->feederItemImage(item->special, i); if (image) { #ifndef CGAME if (item->window.flags & WINDOW_PLAYERCOLOR) { vec4_t color; color[0] = ui_char_color_red.integer/COLOR_MAX; color[1] = ui_char_color_green.integer/COLOR_MAX; color[2] = ui_char_color_blue.integer/COLOR_MAX; color[3] = 1.0f; DC->setColor(color); } #endif DC->drawHandlePic(x+1, y+1, listPtr->elementWidth - 2, listPtr->elementHeight - 2, image); } if (i == item->cursorPos) { DC->drawRect(x, y, listPtr->elementWidth-1, listPtr->elementHeight-1, item->window.borderSize, item->window.borderColor); } sizeWidth -= listPtr->elementWidth; if (sizeWidth < listPtr->elementWidth) { listPtr->drawPadding = sizeWidth; //listPtr->elementWidth - size; break; } x += listPtr->elementWidth; listPtr->endPos++; } sizeHeight -= listPtr->elementHeight; if (sizeHeight < listPtr->elementHeight) { listPtr->drawPadding = sizeHeight; //listPtr->elementWidth - size; break; } // NOTE : Is endPos supposed to be valid or not? It was being used as a valid entry but I changed those // few spots that were causing bugs listPtr->endPos++; startPos = listPtr->endPos; y += listPtr->elementHeight; } } // single column else { x = item->window.rect.x + 1; y = item->window.rect.y + 1; for (i = listPtr->startPos; i < count; i++) { // always draw at least one // which may overdraw the box if it is too small for the element image = DC->feederItemImage(item->special, i); if (image) { DC->drawHandlePic(x+1, y+1, listPtr->elementWidth - 2, listPtr->elementHeight - 2, image); } if (i == item->cursorPos) { DC->drawRect(x, y, listPtr->elementWidth - 1, listPtr->elementHeight - 1, item->window.borderSize, item->window.borderColor); } listPtr->endPos++; sizeHeight -= listPtr->elementHeight; if (sizeHeight < listPtr->elementHeight) { listPtr->drawPadding = listPtr->elementHeight - sizeHeight; break; } y += listPtr->elementHeight; // fit++; } } } else { x = item->window.rect.x + 1; y = item->window.rect.y + 1; //JLF MPMOVED y = item->window.rect.y + 1 - listPtr->elementHeight; #ifdef _XBOX i = listPtr->startPos - (numlines/2); #else i = listPtr->startPos; #endif for (; i < count; i++) //JLF END { const char *text; // always draw at least one // which may overdraw the box if it is too small for the element if (listPtr->numColumns > 0) { int j;//, subX = listPtr->elementHeight; for (j = 0; j < listPtr->numColumns; j++) { char temp[MAX_STRING_CHARS]; int imageStartX = listPtr->columnInfo[j].pos; text = DC->feederItemText(item->special, i, j, &optionalImage1, &optionalImage2, &optionalImage3); if( !text ) { continue; } if (text[0]=='@') { trap_SP_GetStringTextString( &text[1] , temp, sizeof(temp)); text = temp; } /* if (optionalImage >= 0) { DC->drawHandlePic(x + 4 + listPtr->columnInfo[j].pos, y - 1 + listPtr->elementHeight / 2, listPtr->columnInfo[j].width, listPtr->columnInfo[j].width, optionalImage); } else */ if ( text ) { //JLF MPMOVED #ifdef _XBOX float fScaleA = item->textscale; #endif int textyOffset; #ifdef _XBOX textyOffset = DC->textHeight (text, fScaleA, item->iMenuFont); textyOffset *= -1; textyOffset /=2; textyOffset += listPtr->elementHeight/2; #else textyOffset = 0; #endif // DC->drawText(x + 4 + listPtr->columnInfo[j].pos, y + listPtr->elementHeight, item->textscale, item->window.foreColor, text, 0, listPtr->columnInfo[j].maxChars, item->textStyle); //WAS LAST DC->drawText(x + 4 + listPtr->columnInfo[j].pos, y, item->textscale, item->window.foreColor, text, 0, listPtr->columnInfo[j].maxChars, item->textStyle, item->iMenuFont); DC->drawText(x + 4 + listPtr->columnInfo[j].pos, y + listPtr->elementHeight+ textyOffset + item->textaligny, item->textscale, item->window.foreColor, text, 0,listPtr->columnInfo[j].maxChars, item->textStyle, item->iMenuFont); //JLF END } if ( j < listPtr->numColumns - 1 ) { imageStartX = listPtr->columnInfo[j+1].pos; } DC->setColor( NULL ); if (optionalImage3 >= 0) { DC->drawHandlePic(imageStartX - listPtr->elementHeight*3, y+listPtr->elementHeight+2, listPtr->elementHeight, listPtr->elementHeight, optionalImage3); } if (optionalImage2 >= 0) { DC->drawHandlePic(imageStartX - listPtr->elementHeight*2, y+listPtr->elementHeight+2, listPtr->elementHeight, listPtr->elementHeight, optionalImage2); } if (optionalImage1 >= 0) { DC->drawHandlePic(imageStartX - listPtr->elementHeight, y+listPtr->elementHeight+2, listPtr->elementHeight, listPtr->elementHeight, optionalImage1); } } } else { #ifdef _XBOX if (i >= 0) { #endif text = DC->feederItemText(item->special, i, 0, &optionalImage1, &optionalImage2, &optionalImage3 ); if ( optionalImage1 >= 0 || optionalImage2 >= 0 || optionalImage3 >= 0) { //DC->drawHandlePic(x + 4 + listPtr->elementHeight, y, listPtr->columnInfo[j].width, listPtr->columnInfo[j].width, optionalImage); } else if (text) { // DC->drawText(x + 4, y + listPtr->elementHeight, item->textscale, item->window.foreColor, text, 0, 0, item->textStyle); DC->drawText(x + 4, y + item->textaligny, item->textscale, item->window.foreColor, text, 0, 0, item->textStyle, item->iMenuFont); } #ifdef _XBOX } #endif } if (i == item->cursorPos) { DC->fillRect(x + 2, y + listPtr->elementHeight + 2, item->window.rect.w - SCROLLBAR_SIZE - 4, listPtr->elementHeight, item->window.outlineColor); } sizeHeight -= listPtr->elementHeight; if (sizeHeight < listPtr->elementHeight) { listPtr->drawPadding = listPtr->elementHeight - sizeHeight; break; } listPtr->endPos++; y += listPtr->elementHeight; // fit++; } }
        portMissing("Item_ListBox_Paint", source: "oracle/codemp/ui/ui_shared.c:5979")
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:6370
func Item_OwnerDraw_Paint(_ item: ItemDef) {
    var parent: MenuDef?

    if item == nil {
        return
    }
    // Port-note: The draft of this statement did not compile, and the compiler wrote "missing argument label 'handle:' in call".
    // Raven wrote: parent = (menuDef_t*)item->parent
    portMissing("Item_OwnerDraw_Paint", source: "oracle/codemp/ui/ui_shared.c:6370")

    if DC!.ownerDrawItem != nil {
        var color = vec4_t()
        var lowLight = vec4_t()
        // Port-note: The draft of this statement did not compile, and the compiler wrote "missing argument label 'handle:' in call".
        // Raven wrote: menuDef_t *parent = (menuDef_t*)item->parent;
        portMissing("Item_OwnerDraw_Paint", source: "oracle/codemp/ui/ui_shared.c:6370")
        // Port-note: A read of `parent`, a local the draft left as a hole.
        // Raven wrote: Fade(&item->window.flags, &item->window.foreColor[3], parent->fadeClamp, &item->window.nextTime, parent->fadeCycle, qtrue, parent->fadeAmount)
        portMissing("Item_OwnerDraw_Paint", source: "oracle/codemp/ui/ui_shared.c:6370")
        color = vec4_t(item.window.foreColor[0], item.window.foreColor[1], item.window.foreColor[2], item.window.foreColor[3])
        if item.numColors > 0 && DC!.getValue != nil {
            // if the value is within one of the ranges then set color to that, otherwise leave at default
            var i: Int32
            let f: Float = DC!.runGetValue(item.window.ownerDraw)
            i = 0
            while i < item.numColors {
                if f >= item.colorRanges[i].low && f <= item.colorRanges[i].high {
                    color = vec4_t(item.colorRanges[i].color[0], item.colorRanges[i].color[1], item.colorRanges[i].color[2], item.colorRanges[i].color[3])
                    break
                }
                i += 1
            }
        }

        if (item.window.flags & WINDOW_HASFOCUS) != 0 {
            // Port-note: A read of `parent`, a local the draft left as a hole.
            // Raven wrote: lowLight[0] = 0.8 * parent->focusColor[0]
            portMissing("Item_OwnerDraw_Paint", source: "oracle/codemp/ui/ui_shared.c:6370")
            // Port-note: A read of `parent`, a local the draft left as a hole.
            // Raven wrote: lowLight[1] = 0.8 * parent->focusColor[1]
            portMissing("Item_OwnerDraw_Paint", source: "oracle/codemp/ui/ui_shared.c:6370")
            // Port-note: A read of `parent`, a local the draft left as a hole.
            // Raven wrote: lowLight[2] = 0.8 * parent->focusColor[2]
            portMissing("Item_OwnerDraw_Paint", source: "oracle/codemp/ui/ui_shared.c:6370")
            // Port-note: A read of `parent`, a local the draft left as a hole.
            // Raven wrote: lowLight[3] = 0.8 * parent->focusColor[3]
            portMissing("Item_OwnerDraw_Paint", source: "oracle/codemp/ui/ui_shared.c:6370")
            // Port-note: A read of `parent`, a local the draft left as a hole.
            // Raven wrote: LerpColor(parent->focusColor,lowLight,color,0.5+0.5*sin((float)(DC->realTime / PULSE_DIVISOR)))
            portMissing("Item_OwnerDraw_Paint", source: "oracle/codemp/ui/ui_shared.c:6370")
        } else if item.textStyle == ITEM_TEXTSTYLE_BLINK && !(((DC!.realTime / BLINK_DIVISOR) & 1) != 0) {
            lowLight[0] = Float(0.8 * Double(item.window.foreColor[0]))
            lowLight[1] = Float(0.8 * Double(item.window.foreColor[1]))
            lowLight[2] = Float(0.8 * Double(item.window.foreColor[2]))
            lowLight[3] = Float(0.8 * Double(item.window.foreColor[3]))
            LerpColor(vec4_t(item.window.foreColor[0], item.window.foreColor[1], item.window.foreColor[2], item.window.foreColor[3]), lowLight, &color, Float(0.5 + 0.5 * sin(Double(Float((DC!.realTime / PULSE_DIVISOR))))))
        }

        if item.disabled {
            // Port-note: A read of `parent`, a local the draft left as a hole.
            // Raven wrote: memcpy(color, parent->disableColor, sizeof(vec4_t))
            portMissing("Item_OwnerDraw_Paint", source: "oracle/codemp/ui/ui_shared.c:6370")
        }

        if (item.cvarFlags & (CVAR_ENABLE | CVAR_DISABLE)) != 0 && !Item_EnableShowViaCvar(item, CVAR_ENABLE) {
            // Port-note: A read of `parent`, a local the draft left as a hole.
            // Raven wrote: memcpy(color, parent->disableColor, sizeof(vec4_t))
            portMissing("Item_OwnerDraw_Paint", source: "oracle/codemp/ui/ui_shared.c:6370")
        }

        if item.text != nil {
            Item_Text_Paint(item)
            if !item.text!.isEmpty {
                // +8 is an offset kludge to properly align owner draw items that have text combined with them
                DC!.runOwnerDrawItem(item.textRect.x + item.textRect.w + 8, item.window.rect.y, item.window.rect.w, item.window.rect.h, 0, item.textaligny, item.window.ownerDraw, item.window.ownerDrawFlags, item.alignment, item.special, item.textscale, &color, item.window.background, item.textStyle, item.iMenuFont)
            } else {
                DC!.runOwnerDrawItem(item.textRect.x + item.textRect.w, item.window.rect.y, item.window.rect.w, item.window.rect.h, 0, item.textaligny, item.window.ownerDraw, item.window.ownerDrawFlags, item.alignment, item.special, item.textscale, &color, item.window.background, item.textStyle, item.iMenuFont)
            }
        } else {
            DC!.runOwnerDrawItem(item.window.rect.x, item.window.rect.y, item.window.rect.w, item.window.rect.h, item.textalignx, item.textaligny, item.window.ownerDraw, item.window.ownerDrawFlags, item.alignment, item.special, item.textscale, &color, item.window.background, item.textStyle, item.iMenuFont)
        }
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:6433
func Item_Paint(_ item: ItemDef) {
    var red = vec4_t()
    // Port-note: The draft of this statement did not compile, and the compiler wrote "missing argument label 'handle:' in call".
    // Raven wrote: menuDef_t *parent = (menuDef_t*)item->parent;
    portMissing("Item_Paint", source: "oracle/codemp/ui/ui_shared.c:6433")
    var xPos: Int32
    var textWidth: Int32
    var color = vec4_t(1, 1, 1, 1)

    red[3] = 1
    red[0] = red[3]
    red[2] = 0
    red[1] = red[2]

    if item == nil {
        return
    }

    if (item.window.flags & WINDOW_ORBITING) != 0 {
        if DC!.realTime > item.window.nextTime {
            let rx: Float
            let ry: Float
            let a: Float
            let c: Float
            let s: Float
            let w: Float
            let h: Float

            item.window.nextTime = DC!.realTime + item.window.offsetTime
            // translate
            w = item.window.rectClient.w / 2
            h = item.window.rectClient.h / 2
            rx = item.window.rectClient.x + w - item.window.rectEffects.x
            ry = item.window.rectClient.y + h - item.window.rectEffects.y
            // Port-note: The draft of this statement did not compile, and the compiler wrote "ambiguous use of 'M_PI'".
            // Raven wrote: a = 3 * M_PI / 180
            portMissing("Item_Paint", source: "oracle/codemp/ui/ui_shared.c:6433")
            c = cos(a)
            s = sin(a)
            item.window.rectClient.x = (rx * c - ry * s) + item.window.rectEffects.x - w
            item.window.rectClient.y = (rx * s + ry * c) + item.window.rectEffects.y - h
            Item_UpdatePosition(item)
        }
    }


    if (item.window.flags & WINDOW_INTRANSITION) != 0 {
        if DC!.realTime > item.window.nextTime {
            var done: Int32 = 0
            item.window.nextTime = DC!.realTime + item.window.offsetTime

            // transition the x,y
            if item.window.rectClient.x == item.window.rectEffects.x {
                done += 1
            } else {
                if item.window.rectClient.x < item.window.rectEffects.x {
                    item.window.rectClient.x += item.window.rectEffects2.x
                    if item.window.rectClient.x > item.window.rectEffects.x {
                        item.window.rectClient.x = item.window.rectEffects.x
                        done += 1
                    }
                } else {
                    item.window.rectClient.x -= item.window.rectEffects2.x
                    if item.window.rectClient.x < item.window.rectEffects.x {
                        item.window.rectClient.x = item.window.rectEffects.x
                        done += 1
                    }
                }
            }

            if item.window.rectClient.y == item.window.rectEffects.y {
                done += 1
            } else {
                if item.window.rectClient.y < item.window.rectEffects.y {
                    item.window.rectClient.y += item.window.rectEffects2.y
                    if item.window.rectClient.y > item.window.rectEffects.y {
                        item.window.rectClient.y = item.window.rectEffects.y
                        done += 1
                    }
                } else {
                    item.window.rectClient.y -= item.window.rectEffects2.y
                    if item.window.rectClient.y < item.window.rectEffects.y {
                        item.window.rectClient.y = item.window.rectEffects.y
                        done += 1
                    }
                }
            }

            if item.window.rectClient.w == item.window.rectEffects.w {
                done += 1
            } else {
                if item.window.rectClient.w < item.window.rectEffects.w {
                    item.window.rectClient.w += item.window.rectEffects2.w
                    if item.window.rectClient.w > item.window.rectEffects.w {
                        item.window.rectClient.w = item.window.rectEffects.w
                        done += 1
                    }
                } else {
                    item.window.rectClient.w -= item.window.rectEffects2.w
                    if item.window.rectClient.w < item.window.rectEffects.w {
                        item.window.rectClient.w = item.window.rectEffects.w
                        done += 1
                    }
                }
            }

            if item.window.rectClient.h == item.window.rectEffects.h {
                done += 1
            } else {
                if item.window.rectClient.h < item.window.rectEffects.h {
                    item.window.rectClient.h += item.window.rectEffects2.h
                    if item.window.rectClient.h > item.window.rectEffects.h {
                        item.window.rectClient.h = item.window.rectEffects.h
                        done += 1
                    }
                } else {
                    item.window.rectClient.h -= item.window.rectEffects2.h
                    if item.window.rectClient.h < item.window.rectEffects.h {
                        item.window.rectClient.h = item.window.rectEffects.h
                        done += 1
                    }
                }
            }

            Item_UpdatePosition(item)

            if done == 4 {
                item.window.flags &= ~WINDOW_INTRANSITION
            }
        }
    }


    //JLF begin model transition stuff
    if (item.window.flags & WINDOW_INTRANSITIONMODEL) != 0 {
        if item.type == ITEM_TYPE_MODEL {
            //fields ing modelptr
            //				vec3_t g2mins2, g2maxs2, g2minsEffect, g2maxsEffect;
            //	float fov_x2, fov_y2, fov_Effectx, fov_Effecty;

            // Port-note: A pointer local `modelDef_t * modelptr` with no view.
            // Raven wrote: modelDef_t * modelptr = (modelDef_t *)item->typeData;
            portMissing("Item_Paint", source: "oracle/codemp/ui/ui_shared.c:6433")

            if DC!.realTime > item.window.nextTime {
                var done: Int32 = 0
                item.window.nextTime = DC!.realTime + item.window.offsetTime


                // transition the x,y,z max
                // Port-note: A read of `modelptr`, a local the draft left as a hole.
                // Raven wrote: if (modelptr->g2maxs[0] == modelptr->g2maxs2[0]) { done++; } else { if (modelptr->g2maxs[0] < modelptr->g2maxs2[0]) { modelptr->g2maxs[0] += modelptr->g2maxsEffect[0]; if (modelptr->g2maxs[0] > modelptr->g2maxs2[0]) { modelptr->g2maxs[0] = modelptr->g2maxs2[0]; done++; } } else { modelptr->g2maxs[0] -= modelptr->g2maxsEffect[0]; if (modelptr->g2maxs[0] < modelptr->g2maxs2[0]) { modelptr->g2maxs[0] = modelptr->g2maxs2[0]; done++; } } }
                portMissing("Item_Paint", source: "oracle/codemp/ui/ui_shared.c:6433")
                //y
                // Port-note: A read of `modelptr`, a local the draft left as a hole.
                // Raven wrote: if (modelptr->g2maxs[1] == modelptr->g2maxs2[1]) { done++; } else { if (modelptr->g2maxs[1] < modelptr->g2maxs2[1]) { modelptr->g2maxs[1] += modelptr->g2maxsEffect[1]; if (modelptr->g2maxs[1] > modelptr->g2maxs2[1]) { modelptr->g2maxs[1] = modelptr->g2maxs2[1]; done++; } } else { modelptr->g2maxs[1] -= modelptr->g2maxsEffect[1]; if (modelptr->g2maxs[1] < modelptr->g2maxs2[1]) { modelptr->g2maxs[1] = modelptr->g2maxs2[1]; done++; } } }
                portMissing("Item_Paint", source: "oracle/codemp/ui/ui_shared.c:6433")


                //z

                // Port-note: A read of `modelptr`, a local the draft left as a hole.
                // Raven wrote: if (modelptr->g2maxs[2] == modelptr->g2maxs2[2]) { done++; } else { if (modelptr->g2maxs[2] < modelptr->g2maxs2[2]) { modelptr->g2maxs[2] += modelptr->g2maxsEffect[2]; if (modelptr->g2maxs[2] > modelptr->g2maxs2[2]) { modelptr->g2maxs[2] = modelptr->g2maxs2[2]; done++; } } else { modelptr->g2maxs[2] -= modelptr->g2maxsEffect[2]; if (modelptr->g2maxs[2] < modelptr->g2maxs2[2]) { modelptr->g2maxs[2] = modelptr->g2maxs2[2]; done++; } } }
                portMissing("Item_Paint", source: "oracle/codemp/ui/ui_shared.c:6433")

                // transition the x,y,z min
                // Port-note: A read of `modelptr`, a local the draft left as a hole.
                // Raven wrote: if (modelptr->g2mins[0] == modelptr->g2mins2[0]) { done++; } else { if (modelptr->g2mins[0] < modelptr->g2mins2[0]) { modelptr->g2mins[0] += modelptr->g2minsEffect[0]; if (modelptr->g2mins[0] > modelptr->g2mins2[0]) { modelptr->g2mins[0] = modelptr->g2mins2[0]; done++; } } else { modelptr->g2mins[0] -= modelptr->g2minsEffect[0]; if (modelptr->g2mins[0] < modelptr->g2mins2[0]) { modelptr->g2mins[0] = modelptr->g2mins2[0]; done++; } } }
                portMissing("Item_Paint", source: "oracle/codemp/ui/ui_shared.c:6433")
                //y
                // Port-note: A read of `modelptr`, a local the draft left as a hole.
                // Raven wrote: if (modelptr->g2mins[1] == modelptr->g2mins2[1]) { done++; } else { if (modelptr->g2mins[1] < modelptr->g2mins2[1]) { modelptr->g2mins[1] += modelptr->g2minsEffect[1]; if (modelptr->g2mins[1] > modelptr->g2mins2[1]) { modelptr->g2mins[1] = modelptr->g2mins2[1]; done++; } } else { modelptr->g2mins[1] -= modelptr->g2minsEffect[1]; if (modelptr->g2mins[1] < modelptr->g2mins2[1]) { modelptr->g2mins[1] = modelptr->g2mins2[1]; done++; } } }
                portMissing("Item_Paint", source: "oracle/codemp/ui/ui_shared.c:6433")


                //z

                // Port-note: A read of `modelptr`, a local the draft left as a hole.
                // Raven wrote: if (modelptr->g2mins[2] == modelptr->g2mins2[2]) { done++; } else { if (modelptr->g2mins[2] < modelptr->g2mins2[2]) { modelptr->g2mins[2] += modelptr->g2minsEffect[2]; if (modelptr->g2mins[2] > modelptr->g2mins2[2]) { modelptr->g2mins[2] = modelptr->g2mins2[2]; done++; } } else { modelptr->g2mins[2] -= modelptr->g2minsEffect[2]; if (modelptr->g2mins[2] < modelptr->g2mins2[2]) { modelptr->g2mins[2] = modelptr->g2mins2[2]; done++; } } }
                portMissing("Item_Paint", source: "oracle/codemp/ui/ui_shared.c:6433")



                //fovx
                // Port-note: A read of `modelptr`, a local the draft left as a hole.
                // Raven wrote: if (modelptr->fov_x == modelptr->fov_x2) { done++; } else { if (modelptr->fov_x < modelptr->fov_x2) { modelptr->fov_x += modelptr->fov_Effectx; if (modelptr->fov_x > modelptr->fov_x2) { modelptr->fov_x = modelptr->fov_x2; done++; } } else { modelptr->fov_x -= modelptr->fov_Effectx; if (modelptr->fov_x < modelptr->fov_x2) { modelptr->fov_x = modelptr->fov_x2; done++; } } }
                portMissing("Item_Paint", source: "oracle/codemp/ui/ui_shared.c:6433")

                //fovy
                // Port-note: A read of `modelptr`, a local the draft left as a hole.
                // Raven wrote: if (modelptr->fov_y == modelptr->fov_y2) { done++; } else { if (modelptr->fov_y < modelptr->fov_y2) { modelptr->fov_y += modelptr->fov_Effecty; if (modelptr->fov_y > modelptr->fov_y2) { modelptr->fov_y = modelptr->fov_y2; done++; } } else { modelptr->fov_y -= modelptr->fov_Effecty; if (modelptr->fov_y < modelptr->fov_y2) { modelptr->fov_y = modelptr->fov_y2; done++; } } }
                portMissing("Item_Paint", source: "oracle/codemp/ui/ui_shared.c:6433")

                if done == 5 {
                    item.window.flags &= ~WINDOW_INTRANSITIONMODEL
                }
            }
        }
    }
    //JLF end transition stuff for models



    if item.window.ownerDrawFlags != 0 && DC!.ownerDrawVisible != nil {
        if !DC!.runOwnerDrawVisible(item.window.ownerDrawFlags) {
            item.window.flags &= ~WINDOW_VISIBLE
        } else {
            item.window.flags |= WINDOW_VISIBLE
        }
    }

    if (item.cvarFlags & (CVAR_SHOW | CVAR_HIDE)) != 0 {
        if !Item_EnableShowViaCvar(item, CVAR_SHOW) {
            return
        }
    }

    if (item.window.flags & WINDOW_TIMEDVISIBLE) != 0 {
    }

    if !((item.window.flags & WINDOW_VISIBLE) != 0) {
        return
    }


    //JLFMOUSE
    if (item.window.flags & WINDOW_MOUSEOVER) != 0 {
        if item.descText != nil && !Display_KeyBindPending() {
            // Make DOUBLY sure that this item should have desctext.
            // NOTE : we can't just check the mouse position on this, what if we TABBED
            // to the current menu item -- in that case our mouse isn't over the item.
            // Removing the WINDOW_MOUSEOVER flag just prevents the item's OnExit script from running
            //	    if (!Rect_ContainsPoint(&item->window.rect, DC->cursorx, DC->cursory))
            //		{	// It isn't something that should, because it isn't live anymore.
            //			item->window.flags &= ~WINDOW_MOUSEOVER;
            //		}
            //		else
            //END JLFMOUSE
            do {
                // Draw the desctext
                // Port-note: A pointer local `const char * textPtr` with no view.
                // Raven wrote: const char *textPtr = item->descText;
                portMissing("Item_Paint", source: "oracle/codemp/ui/ui_shared.c:6433")
                // Port-note: A pointer dereference the draft cannot place.
                // Raven wrote: if (*textPtr == '@') // string reference { char temp[MAX_STRING_CHARS]; trap_SP_GetStringTextString( &textPtr[1] , temp, sizeof(temp)); textPtr = temp; }
                portMissing("Item_Paint", source: "oracle/codemp/ui/ui_shared.c:6433")

                Item_TextColor(item, &color)

                do {
                    // stupid C language
                    // Port-note: A read of `parent`, a local the draft left as a hole.
                    // Raven wrote: float fDescScale = parent->descScale ? parent->descScale : 1;
                    portMissing("Item_Paint", source: "oracle/codemp/ui/ui_shared.c:6433")
                    // Port-note: A read of `fDescScale`, a local the draft left as a hole.
                    // Raven wrote: float fDescScaleCopy = fDescScale;
                    portMissing("Item_Paint", source: "oracle/codemp/ui/ui_shared.c:6433")
                    var iYadj: Int32 = 0
                    while 1 != 0 {
                        // Port-note: A read of `textPtr`, a local the draft left as a hole.
                        // Raven wrote: textWidth = DC->textWidth(textPtr,fDescScale, FONT_SMALL2)
                        portMissing("Item_Paint", source: "oracle/codemp/ui/ui_shared.c:6433")

                        // Port-note: The draft of this statement did not compile, and the compiler wrote "ambiguous use of 'ITEM_ALIGN_RIGHT'".
                        // Raven wrote: if (parent->descAlignment == ITEM_ALIGN_RIGHT) { xPos = parent->descX - textWidth; // Right justify } else if (parent->descAlignment == ITEM_ALIGN_CENTER) { xPos = parent->descX - (textWidth/2); // Center justify } else // Left justify { xPos = parent->descX; }
                        portMissing("Item_Paint", source: "oracle/codemp/ui/ui_shared.c:6433")

                        // Port-note: The draft of this statement did not compile, and the compiler wrote "ambiguous use of 'ITEM_ALIGN_CENTER'".
                        // Raven wrote: if (parent->descAlignment == ITEM_ALIGN_CENTER) { // only this one will auto-shrink the scale until we eventually fit... // if (xPos + textWidth > (SCREEN_WIDTH-4)) { fDescScale -= 0.001f; continue; } }
                        portMissing("Item_Paint", source: "oracle/codemp/ui/ui_shared.c:6433")

                        // Try to adjust it's y placement if the scale has changed...
                        //
                        // Port-note: A read of `fDescScale`, a local the draft left as a hole.
                        // Raven wrote: if (fDescScale != fDescScaleCopy) { int iOriginalTextHeight = DC->textHeight(textPtr, fDescScaleCopy, FONT_MEDIUM); iYadj = iOriginalTextHeight - DC->textHeight(textPtr, fDescScale, FONT_MEDIUM); }
                        portMissing("Item_Paint", source: "oracle/codemp/ui/ui_shared.c:6433")

                        // Port-note: A read of `parent`, a local the draft left as a hole.
                        // Raven wrote: DC->drawText(xPos, parent->descY + iYadj, fDescScale, parent->descColor, textPtr, 0, 0, item->textStyle, FONT_SMALL2)
                        portMissing("Item_Paint", source: "oracle/codemp/ui/ui_shared.c:6433")
                        break
                    }
                }
            }
        }
    }

    // paint the rect first..
    // Port-note: A read of `parent`, a local the draft left as a hole.
    // Raven wrote: Window_Paint(&item->window, parent->fadeAmount , parent->fadeClamp, parent->fadeCycle)
    portMissing("Item_Paint", source: "oracle/codemp/ui/ui_shared.c:6433")

    // Draw box to show rectangle extents, in debug mode
    if debugMode {
        var color = vec4_t()
        color[3] = 1
        color[1] = color[3]
        color[2] = 0
        color[0] = color[2]
        DC!.runDrawRect(item.window.rect.x, item.window.rect.y, item.window.rect.w, item.window.rect.h, 1, color)
    }

    //DC->drawRect(item->window.rect.x, item->window.rect.y, item->window.rect.w, item->window.rect.h, 1, red);

    switch item.type {
    case ITEM_TYPE_OWNERDRAW:
        Item_OwnerDraw_Paint(item)

    case ITEM_TYPE_TEXT, ITEM_TYPE_BUTTON:
        Item_Text_Paint(item)

    case ITEM_TYPE_RADIOBUTTON:
        break

    case ITEM_TYPE_CHECKBOX:
        break

    case ITEM_TYPE_EDITFIELD, ITEM_TYPE_NUMERICFIELD:
        Item_TextField_Paint(item)

    case ITEM_TYPE_COMBO:
        break

    case ITEM_TYPE_LISTBOX:
        Item_ListBox_Paint(item)

    case ITEM_TYPE_TEXTSCROLL:
        Item_TextScroll_Paint(item)
        //case ITEM_TYPE_IMAGE:
        //  Item_Image_Paint(item);
        //  break;

    case ITEM_TYPE_MODEL:
        Item_Model_Paint(item)

    case ITEM_TYPE_YESNO:
        Item_YesNo_Paint(item)

    case ITEM_TYPE_MULTI:
        Item_Multi_Paint(item)

    case ITEM_TYPE_BIND:
        Item_Bind_Paint(item)

    case ITEM_TYPE_SLIDER:
        Item_Slider_Paint(item)

    default:
        break
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:7015
func Menu_Init(_ menu: MenuDef) {
    menu.clear()
    menu.cursorItem = -1
    menu.fadeAmount = DC!.Assets.fadeAmount
    menu.fadeClamp = DC!.Assets.fadeClamp
    menu.fadeCycle = DC!.Assets.fadeCycle
    Window_Init(menu.window)
}

/// Source: oracle/codemp/ui/ui_shared.c:7024
func Menu_GetFocusedItem(_ menu: MenuDef) -> ItemDef? {
    var i: Int32
    i = 0
    while i < menu.itemCount {
        if (menu.items[i]!.window.flags & WINDOW_HASFOCUS) != 0 {
            return menu.items[i]
        }
        i += 1
    }
    return nil
}

/// Source: oracle/codemp/ui/ui_shared.c:7036
func Menu_GetFocused() -> MenuDef? {
    var i: Int32
    i = 0
    while i < menuCount {
        if (Menus[i].window.flags & WINDOW_HASFOCUS) != 0 && (Menus[i].window.flags & WINDOW_VISIBLE) != 0 {
            return Menus[i]
        }
        i += 1
    }
    return nil
}

/// Source: oracle/codemp/ui/ui_shared.c:7046
func Menu_ScrollFeeder(_ menu: MenuDef, _ feeder: Int32, _ down: Bool) {
    var i: Int32
    i = 0
    while i < menu.itemCount {
        if menu.items[i]!.special == feeder {
            Item_ListBox_HandleKey(menu.items[i]!, (down) ? A_CURSOR_DOWN : A_CURSOR_UP, true, true)
            return
        }
        i += 1
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:7060
func Menu_SetFeederSelection(_ menu: MenuDef, _ feeder: Int32, _ index: Int32, _ name: String?) {
    // Raven assigns his own `menu` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var menu = menu
    if menu == nil {
        if name == nil {
            menu = Menu_GetFocused()!
        } else {
            menu = Menus_FindByName(name!)!
        }
    }

    var i: Int32
    i = 0
    while i < menu.itemCount {
        if menu.items[i]!.special == feeder {
            if index == 0 {
                // Port-note: A pointer local `listBoxDef_t * listPtr` with no view.
                // Raven wrote: listBoxDef_t *listPtr = (listBoxDef_t*)menu->items[i]->typeData;
                portMissing("Menu_SetFeederSelection", source: "oracle/codemp/ui/ui_shared.c:7060")
                // Port-note: A read of `listPtr`, a local the draft left as a hole.
                // Raven wrote: listPtr->cursorPos = 0
                portMissing("Menu_SetFeederSelection", source: "oracle/codemp/ui/ui_shared.c:7060")
                // Port-note: A read of `listPtr`, a local the draft left as a hole.
                // Raven wrote: listPtr->startPos = 0
                portMissing("Menu_SetFeederSelection", source: "oracle/codemp/ui/ui_shared.c:7060")
            }
            menu.items[i]!.cursorPos = index
            DC!.runFeederSelection(menu.items[i]!.special, menu.items[i]!.cursorPos, nil)
            return
        }
        i += 1
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:7086
func Menus_AnyFullScreenVisible() -> Bool {
    var i: Int32
    i = 0
    while i < menuCount {
        if (Menus[i].window.flags & WINDOW_VISIBLE) != 0 && Menus[i].fullScreen {
            return true
        }
        i += 1
    }
    return false
}

/// Source: oracle/codemp/ui/ui_shared.c:7096
func Menus_ActivateByName(_ p: String) -> MenuDef? {
    var i: Int32
    var m: MenuDef? = nil
    let focus: MenuDef? = Menu_GetFocused()
    i = 0
    while i < menuCount {
        if Q_stricmp(Menus[i].window.name!, p) == 0 {
            m = Menus[i]
            Menus_Activate(m!)
            if openMenuCount < MAX_OPEN_MENUS && focus != nil {
                // Port-note: A ++ inside an expression.
                // Raven wrote: menuStack[openMenuCount++] = focus
                portMissing("Menus_ActivateByName", source: "oracle/codemp/ui/ui_shared.c:7096")
            }
        } else {
            Menus[i].window.flags &= ~WINDOW_HASFOCUS
        }
        i += 1
    }
    Display_CloseCinematics()

    // Want to handle a mouse move on the new menu in case your already over an item
    Menu_HandleMouseMove(m!, Float(DC!.cursorx), Float(DC!.cursory))

    return m
}

/// Source: oracle/codemp/ui/ui_shared.c:7120
func Item_Init(_ item: ItemDef) {
    item.clear()
    item.textscale = 0.55
    Window_Init(item.window)
}

/// Source: oracle/codemp/ui/ui_shared.c:7126
func Menu_HandleMouseMove(_ menu: MenuDef, _ x: Float, _ y: Float) {
    //JLFMOUSE  I THINK THIS JUST SETS THE FOCUS BASED ON THE MOUSE
    //END JLF


    var i: Int32
    var pass: Int32
    var focusSet: Bool = false

    var overItem: ItemDef?
    if menu == nil {
        return
    }

    if !((menu.window.flags & (WINDOW_VISIBLE | WINDOW_FORCED)) != 0) {
        return
    }

    if itemCapture != nil {
        //Item_MouseMove(itemCapture, x, y);
        return
    }

    if g_waitingForKey || g_editingField {
        return
    }

    // FIXME: this is the whole issue of focus vs. mouse over..
    // need a better overall solution as i don't like going through everything twice
    pass = 0
    while pass < 2 {
        i = 0
        while i < menu.itemCount {
            // turn off focus each item
            // menu->items[i].window.flags &= ~WINDOW_HASFOCUS;

            if !((menu.items[i]!.window.flags & (WINDOW_VISIBLE | WINDOW_FORCED)) != 0) {
                i += 1
                continue
            }

            if menu.items[i]!.disabled {
                i += 1
                continue
            }

            // items can be enabled and disabled based on cvars
            if (menu.items[i]!.cvarFlags & (CVAR_ENABLE | CVAR_DISABLE)) != 0 && !Item_EnableShowViaCvar(menu.items[i]!, CVAR_ENABLE) {
                i += 1
                continue
            }

            if (menu.items[i]!.cvarFlags & (CVAR_SHOW | CVAR_HIDE)) != 0 && !Item_EnableShowViaCvar(menu.items[i]!, CVAR_SHOW) {
                i += 1
                continue
            }



            if Rect_ContainsPoint(menu.items[i]!.window.rect, x, y) {
                if pass == 1 {
                    overItem = menu.items[i]
                    if overItem!.type == ITEM_TYPE_TEXT && overItem!.text != nil {
                        if !Rect_ContainsPoint(overItem!.window.rect, x, y) {
                            i += 1
                            continue
                        }
                    }
                    // if we are over an item
                    if IsVisible(overItem!.window.flags) {
                        // different one
                        Item_MouseEnter(overItem!, x, y)
                        // Item_SetMouseOver(overItem, qtrue);

                        // if item is not a decoration see if it can take focus
                        if !focusSet {
                            focusSet = Item_SetFocus(overItem!, x, y)
                        }
                    }
                }
            } else if (menu.items[i]!.window.flags & WINDOW_MOUSEOVER) != 0 {
                Item_MouseLeave(menu.items[i]!)
                Item_SetMouseOver(menu.items[i]!, false)
            }
            i += 1
        }
        pass += 1
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:7212
func Menu_Paint(_ menu: MenuDef, _ forcePaint: Bool) {
    var i: Int32

    if menu == nil {
        return
    }

    if !((menu.window.flags & WINDOW_VISIBLE) != 0) && !forcePaint {
        return
    }

    if menu.window.ownerDrawFlags != 0 && DC!.ownerDrawVisible != nil && !DC!.runOwnerDrawVisible(menu.window.ownerDrawFlags) {
        return
    }

    if forcePaint {
        menu.window.flags |= WINDOW_FORCED
    }

    // draw the background if necessary
    if menu.fullScreen {
        // implies a background shader
        // FIXME: make sure we have a default shader if fullscreen is set with no background
        DC!.runDrawHandlePic(0, 0, Float(SCREEN_WIDTH), Float(SCREEN_HEIGHT), menu.window.background)
    } else if menu.window.background != 0 {
        // this allows a background shader without being full screen
        //UI_DrawHandlePic(menu->window.rect.x, menu->window.rect.y, menu->window.rect.w, menu->window.rect.h, menu->backgroundShader);
    }

    // paint the background and or border
    Window_Paint(menu.window, menu.fadeAmount, menu.fadeClamp, Float(menu.fadeCycle))

    // Loop through all items for the menu and paint them
    i = 0
    while i < menu.itemCount {
        if menu.items[i]!.appearanceSlot == 0 {
            Item_Paint(menu.items[i]!)
        } else {
            if menu.appearanceTime < DC!.realTime {
                menu.appearanceTime = DC!.realTime + menu.appearanceIncrement
                menu.appearanceCnt += 1
            }

            if menu.items[i]!.appearanceSlot <= menu.appearanceCnt {
                Item_Paint(menu.items[i]!)
            }
        }
        i += 1
    }

    if debugMode {
        var color = vec4_t()
        color[3] = 1
        color[2] = color[3]
        color[0] = color[2]
        color[1] = 0
        DC!.runDrawRect(menu.window.rect.x, menu.window.rect.y, menu.window.rect.w, menu.window.rect.h, 1, color)
    }
}

/**
```
===============
Item_ValidateTypeData
===============
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:7279
func Item_ValidateTypeData(_ item: ItemDef) {
    if item.typeData != nil {
        return
    }

    if item.type == ITEM_TYPE_LISTBOX {
        // Port-note: A sizeof of `listBoxDef_t` the draft cannot size.
        // Raven wrote: item->typeData = UI_Alloc(sizeof(listBoxDef_t))
        portMissing("Item_ValidateTypeData", source: "oracle/codemp/ui/ui_shared.c:7279")
        // Port-note: Raven's `memset(item->typeData, 0, sizeof(listBoxDef_t))` runs over bytes that are not one record with a view.
        // Raven wrote: memset(item->typeData, 0, sizeof(listBoxDef_t))
        portMissing("Item_ValidateTypeData", source: "oracle/codemp/ui/ui_shared.c:7279")
    } else if item.type == ITEM_TYPE_EDITFIELD || item.type == ITEM_TYPE_NUMERICFIELD || item.type == ITEM_TYPE_YESNO || item.type == ITEM_TYPE_BIND || item.type == ITEM_TYPE_SLIDER || item.type == ITEM_TYPE_TEXT {
        // Port-note: A sizeof of `editFieldDef_t` the draft cannot size.
        // Raven wrote: item->typeData = UI_Alloc(sizeof(editFieldDef_t))
        portMissing("Item_ValidateTypeData", source: "oracle/codemp/ui/ui_shared.c:7279")
        // Port-note: Raven's `memset(item->typeData, 0, sizeof(editFieldDef_t))` runs over bytes that are not one record with a view.
        // Raven wrote: memset(item->typeData, 0, sizeof(editFieldDef_t))
        portMissing("Item_ValidateTypeData", source: "oracle/codemp/ui/ui_shared.c:7279")
        if item.type == ITEM_TYPE_EDITFIELD {
            // Port-note: A cast to `editFieldDef_t *` the draft has no view for.
            // Raven wrote: if (!((editFieldDef_t *) item->typeData)->maxPaintChars) { ((editFieldDef_t *) item->typeData)->maxPaintChars = MAX_EDITFIELD; }
            portMissing("Item_ValidateTypeData", source: "oracle/codemp/ui/ui_shared.c:7279")
        }
    } else if item.type == ITEM_TYPE_MULTI {
        // Port-note: A sizeof of `multiDef_t` the draft cannot size.
        // Raven wrote: item->typeData = UI_Alloc(sizeof(multiDef_t))
        portMissing("Item_ValidateTypeData", source: "oracle/codemp/ui/ui_shared.c:7279")
    } else if item.type == ITEM_TYPE_MODEL {
        // Port-note: A sizeof of `modelDef_t` the draft cannot size.
        // Raven wrote: item->typeData = UI_Alloc(sizeof(modelDef_t))
        portMissing("Item_ValidateTypeData", source: "oracle/codemp/ui/ui_shared.c:7279")
        // Port-note: Raven's `memset(item->typeData, 0, sizeof(modelDef_t))` runs over bytes that are not one record with a view.
        // Raven wrote: memset(item->typeData, 0, sizeof(modelDef_t))
        portMissing("Item_ValidateTypeData", source: "oracle/codemp/ui/ui_shared.c:7279")
    } else if item.type == ITEM_TYPE_TEXTSCROLL {
        // Port-note: A sizeof of `textScrollDef_t` the draft cannot size.
        // Raven wrote: item->typeData = UI_Alloc(sizeof(textScrollDef_t))
        portMissing("Item_ValidateTypeData", source: "oracle/codemp/ui/ui_shared.c:7279")
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:7333
func KeywordHash_Key(_ keyword: String) -> Int32 {
    var hash: Int32
    var i: Int32

    hash = 0
    i = 0
    while CharBuf(keyword)[i] != 0 {
        if CharBuf(keyword)[i] >= Int32(ascii: "A") && CharBuf(keyword)[i] <= Int32(ascii: "Z") {
            hash += (CharBuf(keyword)[i] + (Int32(ascii: "a") - Int32(ascii: "A"))) * (119 + i)
        } else {
            hash += CharBuf(keyword)[i] * (119 + i)
        }
        i += 1
    }
    hash = (hash ^ (hash >> 10) ^ (hash >> 20)) & (KEYWORDHASH_SIZE - 1)
    return hash
}

/// Source: oracle/codemp/ui/ui_shared.c:7347
// AI: Raven passes the bucket table and a row pointer. The function takes the row table beside the buckets, and a row pointer is the row's index.
func KeywordHash_Add(_ table: inout [Int32?], _ rows: inout [KeywordHashRow], _ key: Int32) {
    // TODO: Port KeywordHash_Add
    portMissing("KeywordHash_Add", source: "oracle/codemp/ui/ui_shared.c:7347")
}

/// Source: oracle/codemp/ui/ui_shared.c:7360
// AI: Raven passes the bucket table and returns a row pointer. The function takes the row table beside the buckets and returns the row's index.
func KeywordHash_Find(_ table: [Int32?], _ rows: [KeywordHashRow], _ keyword: String) -> Int32? {
    // TODO: Port KeywordHash_Find
    portMissing("KeywordHash_Find", source: "oracle/codemp/ui/ui_shared.c:7360")
}

// name <string>
/// Source: oracle/codemp/ui/ui_shared.c:7380
func ItemParse_name(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'String?' must be unwrapped to a value of type 'String'".
    // Raven wrote: if (!PC_String_Parse(handle, &item->window.name)) { return qfalse; }
    portMissing("ItemParse_name", source: "oracle/codemp/ui/ui_shared.c:7380")
    return true
}

// name <string>
/// Source: oracle/codemp/ui/ui_shared.c:7388
func ItemParse_focusSound(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return PcToken.scratch { token -> Bool in
        if trap_PC_ReadToken(handle, token) == 0 {
            return false
        }
        item.focusSound = DC!.runRegisterSound(token.string)
        return true
    }
}

// text <string>
/// Source: oracle/codemp/ui/ui_shared.c:7399
func ItemParse_text(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'String?' must be unwrapped to a value of type 'String'".
    // Raven wrote: if (!PC_String_Parse(handle, &item->text)) { return qfalse; }
    portMissing("ItemParse_text", source: "oracle/codemp/ui/ui_shared.c:7399")
    return true
}

/**
```
===============
ItemParse_descText
	text <string>
===============
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:7412
func ItemParse_descText(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'String?' must be unwrapped to a value of type 'String'".
    // Raven wrote: if (!PC_String_Parse(handle, &item->descText)) { return qfalse; }
    portMissing("ItemParse_descText", source: "oracle/codemp/ui/ui_shared.c:7412")

    return true
}

/**
```
===============
ItemParse_text
	text <string>
===============
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:7431
func ItemParse_text2(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'String?' must be unwrapped to a value of type 'String'".
    // Raven wrote: if (!PC_String_Parse(handle, &item->text2)) { return qfalse; }
    portMissing("ItemParse_text2", source: "oracle/codemp/ui/ui_shared.c:7431")

    return true
}

/**
```
===============
ItemParse_text2alignx
===============
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:7448
func ItemParse_text2alignx(_ item: ItemDef, _ handle: Int32) -> Bool {
    if !PC_Float_Parse(handle, &item.text2alignx) {
        return false
    }
    return true
}

/**
```
===============
ItemParse_text2aligny
===============
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:7462
func ItemParse_text2aligny(_ item: ItemDef, _ handle: Int32) -> Bool {
    if !PC_Float_Parse(handle, &item.text2aligny) {
        return false
    }
    return true
}

// group <string>
/// Source: oracle/codemp/ui/ui_shared.c:7472
func ItemParse_group(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'String?' must be unwrapped to a value of type 'String'".
    // Raven wrote: if (!PC_String_Parse(handle, &item->window.group)) { return qfalse; }
    portMissing("ItemParse_group", source: "oracle/codemp/ui/ui_shared.c:7472")
    return true
}

//Insert the pointer into our chain so we can keep track of it for freeing.
/// Source: oracle/codemp/ui/ui_shared.c:7492
func UI_InsertG2Pointer(_ ghoul2: OpaquePointer?) {
    // Port-note: A pointer local `uiG2PtrTracker_t ** nextFree` with no view.
    // Raven wrote: uiG2PtrTracker_t **nextFree = &ui_G2PtrTracker;
    portMissing("UI_InsertG2Pointer", source: "oracle/codemp/ui/ui_shared.c:7492")

    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: while ((*nextFree) && (*nextFree)->ghoul2) { //check if it has a ghoul2, if not we can reuse it. nextFree = &((*nextFree)->next); }
    portMissing("UI_InsertG2Pointer", source: "oracle/codemp/ui/ui_shared.c:7492")

    // Port-note: A read of `nextFree`, a local the draft left as a hole.
    // Raven wrote: if (!nextFree) { //shouldn't happen assert(0); return; }
    portMissing("UI_InsertG2Pointer", source: "oracle/codemp/ui/ui_shared.c:7492")

    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: if (!(*nextFree)) { //if we aren't reusing a chain then allocate space for it. (*nextFree) = (uiG2PtrTracker_t *)BG_Alloc(sizeof(uiG2PtrTracker_t)); (*nextFree)->next = NULL; }
    portMissing("UI_InsertG2Pointer", source: "oracle/codemp/ui/ui_shared.c:7492")

    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: (*nextFree)->ghoul2 = ghoul2
    portMissing("UI_InsertG2Pointer", source: "oracle/codemp/ui/ui_shared.c:7492")
}

//Remove a ghoul2 pointer from the chain if it's there.
/// Source: oracle/codemp/ui/ui_shared.c:7517
func UI_ClearG2Pointer(_ ghoul2: OpaquePointer?) {
    // Port-note: A pointer local `uiG2PtrTracker_t * next` with no view.
    // Raven wrote: uiG2PtrTracker_t *next = ui_G2PtrTracker;
    portMissing("UI_ClearG2Pointer", source: "oracle/codemp/ui/ui_shared.c:7517")

    if ghoul2 == nil {
        return
    }

    // Port-note: A read of `next`, a local the draft left as a hole.
    // Raven wrote: while (next) { if (next->ghoul2 == ghoul2) { //found it, set it to null so we can reuse this link. next->ghoul2 = NULL; break; } next = next->next; }
    portMissing("UI_ClearG2Pointer", source: "oracle/codemp/ui/ui_shared.c:7517")
}

//Called on shutdown, cleans up all the ghoul2 instances laying around.
/// Source: oracle/codemp/ui/ui_shared.c:7539
func UI_CleanupGhoul2() {
    // Port-note: A pointer local `uiG2PtrTracker_t * next` with no view.
    // Raven wrote: uiG2PtrTracker_t *next = ui_G2PtrTracker;
    portMissing("UI_CleanupGhoul2", source: "oracle/codemp/ui/ui_shared.c:7539")

    // Port-note: A read of `next`, a local the draft left as a hole.
    // Raven wrote: while (next) { if (next->ghoul2 && trap_G2_HaveWeGhoul2Models(next->ghoul2)) { //found a g2 instance, clean it. trap_G2API_CleanGhoul2Models(&next->ghoul2); } next = next->next; }
    portMissing("UI_CleanupGhoul2", source: "oracle/codemp/ui/ui_shared.c:7539")
}

/**
```
===============
ItemParse_asset_model
	asset_model <string>
===============
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:7567
func ItemParse_asset_model_go(_ item: ItemDef, _ name: String, _ runTimeLength: inout Int32) -> Bool {
    //					DC->g2hilev_SetAnim(&item->ghoul2[0], "model_root", modelPtr->g2anim);










    //					DC->g2_SetSkin( &item->ghoul2[0], 0, modelPtr->g2skin );//this is going to set the surfs on/off matching the skin file
    //trap_G2API_InitGhoul2Model(&item->ghoul2, name, 0, modelPtr->g2skin, 0, 0, 0);
    //ahh, what are you doing?!
    /*
    else
    {
    Com_Error(ERR_FATAL, "%s does not exist.", name);
    }
    */
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:7659
func ItemParse_asset_model(_ item: ItemDef, _ handle: Int32) -> Bool {
    var temp: String
    // Port-note: A pointer local `modelDef_t * modelPtr` with no view.
    // Raven wrote: modelDef_t *modelPtr;
    portMissing("ItemParse_asset_model", source: "oracle/codemp/ui/ui_shared.c:7659")
    var animRunLength: Int32 = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return PcToken.scratch { token -> Bool in

        Item_ValidateTypeData(item)
        // Port-note: A store into `modelPtr`, a local the draft left as a hole.
        // Raven wrote: modelPtr = (modelDef_t*)item->typeData
        portMissing("ItemParse_asset_model", source: "oracle/codemp/ui/ui_shared.c:7659")

        if trap_PC_ReadToken(handle, token) == 0 {
            return false
        }
        temp = token.string

        return (ItemParse_asset_model_go(item, temp, &animRunLength))
    }
}

// asset_shader <string>
/// Source: oracle/codemp/ui/ui_shared.c:7687
func ItemParse_asset_shader(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return PcToken.scratch { token -> Bool in
        if trap_PC_ReadToken(handle, token) == 0 {
            return false
        }
        item.asset = DC!.runRegisterShaderNoMip(token.string)
        return true
    }
}

// model_origin <number> <number> <number>
/// Source: oracle/codemp/ui/ui_shared.c:7697
func ItemParse_model_origin(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: A pointer local `modelDef_t * modelPtr` with no view.
    // Raven wrote: modelDef_t *modelPtr;
    portMissing("ItemParse_model_origin", source: "oracle/codemp/ui/ui_shared.c:7697")
    Item_ValidateTypeData(item)
    // Port-note: A store into `modelPtr`, a local the draft left as a hole.
    // Raven wrote: modelPtr = (modelDef_t*)item->typeData
    portMissing("ItemParse_model_origin", source: "oracle/codemp/ui/ui_shared.c:7697")

    // Port-note: A read of `modelPtr`, a local the draft left as a hole.
    // Raven wrote: if (PC_Float_Parse(handle, &modelPtr->origin[0])) { if (PC_Float_Parse(handle, &modelPtr->origin[1])) { if (PC_Float_Parse(handle, &modelPtr->origin[2])) { return qtrue; } } }
    portMissing("ItemParse_model_origin", source: "oracle/codemp/ui/ui_shared.c:7697")
    return false
}

// model_fovx <number>
/// Source: oracle/codemp/ui/ui_shared.c:7713
func ItemParse_model_fovx(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: A pointer local `modelDef_t * modelPtr` with no view.
    // Raven wrote: modelDef_t *modelPtr;
    portMissing("ItemParse_model_fovx", source: "oracle/codemp/ui/ui_shared.c:7713")
    Item_ValidateTypeData(item)
    // Port-note: A store into `modelPtr`, a local the draft left as a hole.
    // Raven wrote: modelPtr = (modelDef_t*)item->typeData
    portMissing("ItemParse_model_fovx", source: "oracle/codemp/ui/ui_shared.c:7713")

    // Port-note: A read of `modelPtr`, a local the draft left as a hole.
    // Raven wrote: if (!PC_Float_Parse(handle, &modelPtr->fov_x)) { return qfalse; }
    portMissing("ItemParse_model_fovx", source: "oracle/codemp/ui/ui_shared.c:7713")
    return true
}

// model_fovy <number>
/// Source: oracle/codemp/ui/ui_shared.c:7725
func ItemParse_model_fovy(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: A pointer local `modelDef_t * modelPtr` with no view.
    // Raven wrote: modelDef_t *modelPtr;
    portMissing("ItemParse_model_fovy", source: "oracle/codemp/ui/ui_shared.c:7725")
    Item_ValidateTypeData(item)
    // Port-note: A store into `modelPtr`, a local the draft left as a hole.
    // Raven wrote: modelPtr = (modelDef_t*)item->typeData
    portMissing("ItemParse_model_fovy", source: "oracle/codemp/ui/ui_shared.c:7725")

    // Port-note: A read of `modelPtr`, a local the draft left as a hole.
    // Raven wrote: if (!PC_Float_Parse(handle, &modelPtr->fov_y)) { return qfalse; }
    portMissing("ItemParse_model_fovy", source: "oracle/codemp/ui/ui_shared.c:7725")
    return true
}

// model_rotation <integer>
/// Source: oracle/codemp/ui/ui_shared.c:7737
func ItemParse_model_rotation(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: A pointer local `modelDef_t * modelPtr` with no view.
    // Raven wrote: modelDef_t *modelPtr;
    portMissing("ItemParse_model_rotation", source: "oracle/codemp/ui/ui_shared.c:7737")
    Item_ValidateTypeData(item)
    // Port-note: A store into `modelPtr`, a local the draft left as a hole.
    // Raven wrote: modelPtr = (modelDef_t*)item->typeData
    portMissing("ItemParse_model_rotation", source: "oracle/codemp/ui/ui_shared.c:7737")

    // Port-note: A read of `modelPtr`, a local the draft left as a hole.
    // Raven wrote: if (!PC_Int_Parse(handle, &modelPtr->rotationSpeed)) { return qfalse; }
    portMissing("ItemParse_model_rotation", source: "oracle/codemp/ui/ui_shared.c:7737")
    return true
}

// model_angle <integer>
/// Source: oracle/codemp/ui/ui_shared.c:7749
func ItemParse_model_angle(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: A pointer local `modelDef_t * modelPtr` with no view.
    // Raven wrote: modelDef_t *modelPtr;
    portMissing("ItemParse_model_angle", source: "oracle/codemp/ui/ui_shared.c:7749")
    Item_ValidateTypeData(item)
    // Port-note: A store into `modelPtr`, a local the draft left as a hole.
    // Raven wrote: modelPtr = (modelDef_t*)item->typeData
    portMissing("ItemParse_model_angle", source: "oracle/codemp/ui/ui_shared.c:7749")

    // Port-note: A read of `modelPtr`, a local the draft left as a hole.
    // Raven wrote: if (!PC_Int_Parse(handle, &modelPtr->angle)) { return qfalse; }
    portMissing("ItemParse_model_angle", source: "oracle/codemp/ui/ui_shared.c:7749")
    return true
}

// model_g2mins <number> <number> <number>
/// Source: oracle/codemp/ui/ui_shared.c:7761
func ItemParse_model_g2mins(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: A pointer local `modelDef_t * modelPtr` with no view.
    // Raven wrote: modelDef_t *modelPtr;
    portMissing("ItemParse_model_g2mins", source: "oracle/codemp/ui/ui_shared.c:7761")
    Item_ValidateTypeData(item)
    // Port-note: A store into `modelPtr`, a local the draft left as a hole.
    // Raven wrote: modelPtr = (modelDef_t*)item->typeData
    portMissing("ItemParse_model_g2mins", source: "oracle/codemp/ui/ui_shared.c:7761")

    // Port-note: A read of `modelPtr`, a local the draft left as a hole.
    // Raven wrote: if (PC_Float_Parse(handle, &modelPtr->g2mins[0])) { if (PC_Float_Parse(handle, &modelPtr->g2mins[1])) { if (PC_Float_Parse(handle, &modelPtr->g2mins[2])) { return qtrue; } } }
    portMissing("ItemParse_model_g2mins", source: "oracle/codemp/ui/ui_shared.c:7761")
    return false
}

// model_g2maxs <number> <number> <number>
/// Source: oracle/codemp/ui/ui_shared.c:7777
func ItemParse_model_g2maxs(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: A pointer local `modelDef_t * modelPtr` with no view.
    // Raven wrote: modelDef_t *modelPtr;
    portMissing("ItemParse_model_g2maxs", source: "oracle/codemp/ui/ui_shared.c:7777")
    Item_ValidateTypeData(item)
    // Port-note: A store into `modelPtr`, a local the draft left as a hole.
    // Raven wrote: modelPtr = (modelDef_t*)item->typeData
    portMissing("ItemParse_model_g2maxs", source: "oracle/codemp/ui/ui_shared.c:7777")

    // Port-note: A read of `modelPtr`, a local the draft left as a hole.
    // Raven wrote: if (PC_Float_Parse(handle, &modelPtr->g2maxs[0])) { if (PC_Float_Parse(handle, &modelPtr->g2maxs[1])) { if (PC_Float_Parse(handle, &modelPtr->g2maxs[2])) { return qtrue; } } }
    portMissing("ItemParse_model_g2maxs", source: "oracle/codemp/ui/ui_shared.c:7777")
    return false
}

// model_g2scale <number> <number> <number>
/// Source: oracle/codemp/ui/ui_shared.c:7793
func ItemParse_model_g2scale(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: A pointer local `modelDef_t * modelPtr` with no view.
    // Raven wrote: modelDef_t *modelPtr;
    portMissing("ItemParse_model_g2scale", source: "oracle/codemp/ui/ui_shared.c:7793")
    Item_ValidateTypeData(item)
    // Port-note: A store into `modelPtr`, a local the draft left as a hole.
    // Raven wrote: modelPtr = (modelDef_t*)item->typeData
    portMissing("ItemParse_model_g2scale", source: "oracle/codemp/ui/ui_shared.c:7793")

    // Port-note: A read of `modelPtr`, a local the draft left as a hole.
    // Raven wrote: if (PC_Float_Parse(handle, &modelPtr->g2scale[0])) { if (PC_Float_Parse(handle, &modelPtr->g2scale[1])) { if (PC_Float_Parse(handle, &modelPtr->g2scale[2])) { return qtrue; } } }
    portMissing("ItemParse_model_g2scale", source: "oracle/codemp/ui/ui_shared.c:7793")
    return false
}

/// Source: oracle/codemp/ui/ui_shared.c:7811
func ItemParse_model_g2skin(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: A pointer local `modelDef_t * modelPtr` with no view.
    // Raven wrote: modelDef_t *modelPtr;
    portMissing("ItemParse_model_g2skin", source: "oracle/codemp/ui/ui_shared.c:7811")
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return PcToken.scratch { token -> Bool in

        Item_ValidateTypeData(item)
        // Port-note: A store into `modelPtr`, a local the draft left as a hole.
        // Raven wrote: modelPtr = (modelDef_t*)item->typeData
        portMissing("ItemParse_model_g2skin", source: "oracle/codemp/ui/ui_shared.c:7811")

        if trap_PC_ReadToken(handle, token) == 0 {
            return false
        }

        if token.string.isEmpty {
            //it was parsed correctly so still return true.
            return true
        }

        // Port-note: A read of `modelPtr`, a local the draft left as a hole.
        // Raven wrote: modelPtr->g2skin = trap_R_RegisterSkin(token.string)
        portMissing("ItemParse_model_g2skin", source: "oracle/codemp/ui/ui_shared.c:7811")

        return true
    }
}

// model_g2anim <number>
/// Source: oracle/codemp/ui/ui_shared.c:7833
func ItemParse_model_g2anim(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: A pointer local `modelDef_t * modelPtr` with no view.
    // Raven wrote: modelDef_t *modelPtr;
    portMissing("ItemParse_model_g2anim", source: "oracle/codemp/ui/ui_shared.c:7833")
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return PcToken.scratch { token -> Bool in
        var i: Int32 = 0

        Item_ValidateTypeData(item)
        // Port-note: A store into `modelPtr`, a local the draft left as a hole.
        // Raven wrote: modelPtr = (modelDef_t*)item->typeData
        portMissing("ItemParse_model_g2anim", source: "oracle/codemp/ui/ui_shared.c:7833")

        if trap_PC_ReadToken(handle, token) == 0 {
            return false
        }

        if token.string.isEmpty {
            //it was parsed correctly so still return true.
            return true
        }

        while i < MAX_ANIMATIONS {
            if Q_stricmp(token.string, animTable[i].name!) == 0 {
                //found it
                // Port-note: A read of `modelPtr`, a local the draft left as a hole.
                // Raven wrote: modelPtr->g2anim = i
                portMissing("ItemParse_model_g2anim", source: "oracle/codemp/ui/ui_shared.c:7833")
                return true
            }
            i += 1
        }

        Com_Printf("Could not find '%s' in the anim table\n", token.string)
        return true
    }
}

// model_g2skin <string>
/// Source: oracle/codemp/ui/ui_shared.c:7865
func ItemParse_model_g2skin_go(_ item: ItemDef, _ skinName: String) -> Bool {
    // Port-note: A pointer local `modelDef_t * modelPtr` with no view.
    // Raven wrote: modelDef_t *modelPtr;
    portMissing("ItemParse_model_g2skin_go", source: "oracle/codemp/ui/ui_shared.c:7865")
    let defSkin: Int32


    Item_ValidateTypeData(item)
    // Port-note: A store into `modelPtr`, a local the draft left as a hole.
    // Raven wrote: modelPtr = (modelDef_t*)item->typeData
    portMissing("ItemParse_model_g2skin_go", source: "oracle/codemp/ui/ui_shared.c:7865")

    if skinName.isEmpty {
        //it was parsed correctly so still return true.
        // Port-note: A read of `modelPtr`, a local the draft left as a hole.
        // Raven wrote: modelPtr->g2skin = 0
        portMissing("ItemParse_model_g2skin_go", source: "oracle/codemp/ui/ui_shared.c:7865")
        trap_G2API_SetSkin(item.ghoul2, 0, 0, 0)

        return true
    }

    // set skin
    if item.ghoul2 != nil {
        defSkin = trap_R_RegisterSkin(skinName)
        trap_G2API_SetSkin(item.ghoul2, 0, defSkin, defSkin)
    }

    return true
}

// model_g2anim <number>
/// Source: oracle/codemp/ui/ui_shared.c:7894
func ItemParse_model_g2anim_go(_ item: ItemDef, _ animName: String) -> Bool {
    // Port-note: A pointer local `modelDef_t * modelPtr` with no view.
    // Raven wrote: modelDef_t *modelPtr;
    portMissing("ItemParse_model_g2anim_go", source: "oracle/codemp/ui/ui_shared.c:7894")
    var i: Int32 = 0

    Item_ValidateTypeData(item)
    // Port-note: A store into `modelPtr`, a local the draft left as a hole.
    // Raven wrote: modelPtr = (modelDef_t*)item->typeData
    portMissing("ItemParse_model_g2anim_go", source: "oracle/codemp/ui/ui_shared.c:7894")

    if animName.isEmpty {
        //it was parsed correctly so still return true.
        return true
    }

    while i < MAX_ANIMATIONS {
        if Q_stricmp(animName, animTable[i].name!) == 0 {
            //found it
            // Port-note: A read of `modelPtr`, a local the draft left as a hole.
            // Raven wrote: modelPtr->g2anim = animTable[i].id
            portMissing("ItemParse_model_g2anim_go", source: "oracle/codemp/ui/ui_shared.c:7894")
            return true
        }
        i += 1
    }

    Com_Printf("Could not find '%s' in the anim table\n", animName)
    return true
}

// Get the cvar, get the values and stuff them in the rect structure.
/// Source: oracle/codemp/ui/ui_shared.c:7922
func ItemParse_rectcvar(_ item: ItemDef, _ handle: Int32) -> Bool {
    var cvarBuf = CharBuf(1024)
    // Port-note: A pointer local `const char * holdVal` with no view.
    // Raven wrote: const char *holdVal;
    portMissing("ItemParse_rectcvar", source: "oracle/codemp/ui/ui_shared.c:7922")
    var holdBuf = TextCursor()

    // get Cvar name
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return PcToken.scratch { token -> Bool in
        if trap_PC_ReadToken(handle, token) == 0 {
            return false
        }

        // get cvar data
        // Port-note: Raven passes the buffer `cvarBuf` to the engine as a handle, and the trap takes an OpaquePointer.
        // Raven wrote: DC->getCVarString(token.string, cvarBuf, sizeof(cvarBuf))
        portMissing("ItemParse_rectcvar", source: "oracle/codemp/ui/ui_shared.c:7922")

        holdBuf = TextCursor(cvarBuf)
        // Port-note: A read of `holdVal`, a local the draft left as a hole.
        // Raven wrote: if (String_Parse(&holdBuf,&holdVal)) { item->window.rectClient.x = atof(holdVal); if (String_Parse(&holdBuf,&holdVal)) { item->window.rectClient.y = atof(holdVal); if (String_Parse(&holdBuf,&holdVal)) { item->window.rectClient.w = atof(holdVal); if (String_Parse(&holdBuf,&holdVal)) { item->window.rectClient.h = atof(holdVal); return qtrue; } } } }
        portMissing("ItemParse_rectcvar", source: "oracle/codemp/ui/ui_shared.c:7922")

        // There may be no cvar built for this, and that's okay. . . I guess.
        return true
    }
}

// rect <rectangle>
/// Source: oracle/codemp/ui/ui_shared.c:7962
func ItemParse_rect(_ item: ItemDef, _ handle: Int32) -> Bool {
    if !PC_Rect_Parse(handle, item.window.rectClient) {
        return false
    }
    return true
}

/**
```
===============
ItemParse_flag
	style <integer>
===============
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:7975
func ItemParse_flag(_ item: ItemDef, _ handle: Int32) -> Bool {
    var i: Int32 = 0
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return PcToken.scratch { token -> Bool in

        if trap_PC_ReadToken(handle, token) == 0 {
            return false
        }

        i = 0
        while styles[i] != nil {
            // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'itemFlags' in scope".
            // Raven wrote: if (Q_stricmp(token.string,itemFlags[i].string)==0) { item->window.flags |= itemFlags[i].value; break; }
            portMissing("ItemParse_flag", source: "oracle/codemp/ui/ui_shared.c:7975")
            i += 1
        }

        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'itemFlags' in scope".
        // Raven wrote: if (itemFlags[i].string == NULL) { Com_Printf(va( S_COLOR_YELLOW "Unknown item style value '%s'",token.string)); }
        portMissing("ItemParse_flag", source: "oracle/codemp/ui/ui_shared.c:7975")

        return true
    }
}

/**
```
===============
ItemParse_style
	style <integer>
===============
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:8010
func ItemParse_style(_ item: ItemDef, _ handle: Int32) -> Bool {
    if !PC_Int_Parse(handle, &item.window.style) {
        Com_Printf(S_COLOR_YELLOW + "Unknown item style value")
        return false
    }

    return true
}

// decoration
/// Source: oracle/codemp/ui/ui_shared.c:8023
func ItemParse_decoration(_ item: ItemDef, _ handle: Int32) -> Bool {
    item.window.flags |= WINDOW_DECORATION
    return true
}

// notselectable
/// Source: oracle/codemp/ui/ui_shared.c:8029
func ItemParse_notselectable(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: A pointer local `listBoxDef_t * listPtr` with no view.
    // Raven wrote: listBoxDef_t *listPtr;
    portMissing("ItemParse_notselectable", source: "oracle/codemp/ui/ui_shared.c:8029")
    Item_ValidateTypeData(item)
    // Port-note: A store into `listPtr`, a local the draft left as a hole.
    // Raven wrote: listPtr = (listBoxDef_t*)item->typeData
    portMissing("ItemParse_notselectable", source: "oracle/codemp/ui/ui_shared.c:8029")
    // Port-note: A read of `listPtr`, a local the draft left as a hole.
    // Raven wrote: if (item->type == ITEM_TYPE_LISTBOX && listPtr) { listPtr->notselectable = qtrue; }
    portMissing("ItemParse_notselectable", source: "oracle/codemp/ui/ui_shared.c:8029")
    return true
}

/**
```
===============
ItemParse_scrollhidden
	scrollhidden
===============
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:8045
func ItemParse_scrollhidden(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: A pointer local `listBoxDef_t * listPtr` with no view.
    // Raven wrote: listBoxDef_t *listPtr;
    portMissing("ItemParse_scrollhidden", source: "oracle/codemp/ui/ui_shared.c:8045")
    Item_ValidateTypeData(item)
    // Port-note: A store into `listPtr`, a local the draft left as a hole.
    // Raven wrote: listPtr = (listBoxDef_t*)item->typeData
    portMissing("ItemParse_scrollhidden", source: "oracle/codemp/ui/ui_shared.c:8045")

    // Port-note: A read of `listPtr`, a local the draft left as a hole.
    // Raven wrote: if (item->type == ITEM_TYPE_LISTBOX && listPtr) { listPtr->scrollhidden = qtrue; }
    portMissing("ItemParse_scrollhidden", source: "oracle/codemp/ui/ui_shared.c:8045")
    return true
}

// manually wrapped
/// Source: oracle/codemp/ui/ui_shared.c:8063
func ItemParse_wrapped(_ item: ItemDef, _ handle: Int32) -> Bool {
    item.window.flags |= WINDOW_WRAPPED
    return true
}

// auto wrapped
/// Source: oracle/codemp/ui/ui_shared.c:8069
func ItemParse_autowrapped(_ item: ItemDef, _ handle: Int32) -> Bool {
    item.window.flags |= WINDOW_AUTOWRAPPED
    return true
}

// horizontalscroll
/// Source: oracle/codemp/ui/ui_shared.c:8076
func ItemParse_horizontalscroll(_ item: ItemDef, _ handle: Int32) -> Bool {
    item.window.flags |= WINDOW_HORIZONTAL
    return true
}

/**
```
===============
ItemParse_type
	type <integer>
===============
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:8087
func ItemParse_type(_ item: ItemDef, _ handle: Int32) -> Bool {
    //	int		i,holdInt;

    if !PC_Int_Parse(handle, &item.type) {
        return false
    }
    Item_ValidateTypeData(item)
    return true
}

// elementwidth, used for listbox image elements
// uses textalignx for storage
/// Source: oracle/codemp/ui/ui_shared.c:8101
func ItemParse_elementwidth(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: A pointer local `listBoxDef_t * listPtr` with no view.
    // Raven wrote: listBoxDef_t *listPtr;
    portMissing("ItemParse_elementwidth", source: "oracle/codemp/ui/ui_shared.c:8101")

    Item_ValidateTypeData(item)
    // Port-note: A store into `listPtr`, a local the draft left as a hole.
    // Raven wrote: listPtr = (listBoxDef_t*)item->typeData
    portMissing("ItemParse_elementwidth", source: "oracle/codemp/ui/ui_shared.c:8101")
    // Port-note: A read of `listPtr`, a local the draft left as a hole.
    // Raven wrote: if (!PC_Float_Parse(handle, &listPtr->elementWidth)) { return qfalse; }
    portMissing("ItemParse_elementwidth", source: "oracle/codemp/ui/ui_shared.c:8101")
    return true
}

// elementheight, used for listbox image elements
// uses textaligny for storage
/// Source: oracle/codemp/ui/ui_shared.c:8114
func ItemParse_elementheight(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: A pointer local `listBoxDef_t * listPtr` with no view.
    // Raven wrote: listBoxDef_t *listPtr;
    portMissing("ItemParse_elementheight", source: "oracle/codemp/ui/ui_shared.c:8114")

    Item_ValidateTypeData(item)
    // Port-note: A store into `listPtr`, a local the draft left as a hole.
    // Raven wrote: listPtr = (listBoxDef_t*)item->typeData
    portMissing("ItemParse_elementheight", source: "oracle/codemp/ui/ui_shared.c:8114")
    // Port-note: A read of `listPtr`, a local the draft left as a hole.
    // Raven wrote: if (!PC_Float_Parse(handle, &listPtr->elementHeight)) { return qfalse; }
    portMissing("ItemParse_elementheight", source: "oracle/codemp/ui/ui_shared.c:8114")
    return true
}

// feeder <float>
/// Source: oracle/codemp/ui/ui_shared.c:8126
func ItemParse_feeder(_ item: ItemDef, _ handle: Int32) -> Bool {
    if !PC_Float_Parse(handle, &item.special) {
        return false
    }
    return true
}

// elementtype, used to specify what type of elements a listbox contains
// uses textstyle for storage
/// Source: oracle/codemp/ui/ui_shared.c:8135
func ItemParse_elementtype(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: A pointer local `listBoxDef_t * listPtr` with no view.
    // Raven wrote: listBoxDef_t *listPtr;
    portMissing("ItemParse_elementtype", source: "oracle/codemp/ui/ui_shared.c:8135")

    Item_ValidateTypeData(item)
    if item.typeData == nil {
        return false
    }
    // Port-note: A store into `listPtr`, a local the draft left as a hole.
    // Raven wrote: listPtr = (listBoxDef_t*)item->typeData
    portMissing("ItemParse_elementtype", source: "oracle/codemp/ui/ui_shared.c:8135")
    // Port-note: A read of `listPtr`, a local the draft left as a hole.
    // Raven wrote: if (!PC_Int_Parse(handle, &listPtr->elementStyle)) { return qfalse; }
    portMissing("ItemParse_elementtype", source: "oracle/codemp/ui/ui_shared.c:8135")
    return true
}

// columns sets a number of columns and an x pos and width per..
/// Source: oracle/codemp/ui/ui_shared.c:8149
func ItemParse_columns(_ item: ItemDef, _ handle: Int32) -> Bool {
    var num: Int32 = 0
    var i: Int32
    // Port-note: A pointer local `listBoxDef_t * listPtr` with no view.
    // Raven wrote: listBoxDef_t *listPtr;
    portMissing("ItemParse_columns", source: "oracle/codemp/ui/ui_shared.c:8149")

    Item_ValidateTypeData(item)
    if item.typeData == nil {
        return false
    }
    // Port-note: A store into `listPtr`, a local the draft left as a hole.
    // Raven wrote: listPtr = (listBoxDef_t*)item->typeData
    portMissing("ItemParse_columns", source: "oracle/codemp/ui/ui_shared.c:8149")
    if PC_Int_Parse(handle, &num) {
        if num > MAX_LB_COLUMNS {
            num = MAX_LB_COLUMNS
        }
        // Port-note: A read of `listPtr`, a local the draft left as a hole.
        // Raven wrote: listPtr->numColumns = num
        portMissing("ItemParse_columns", source: "oracle/codemp/ui/ui_shared.c:8149")
        i = 0
        while i < num {
            var pos: Int32 = 0
            var width: Int32 = 0
            var maxChars: Int32 = 0

            if PC_Int_Parse(handle, &pos) && PC_Int_Parse(handle, &width) && PC_Int_Parse(handle, &maxChars) {
                // Port-note: A read of `listPtr`, a local the draft left as a hole.
                // Raven wrote: listPtr->columnInfo[i].pos = pos
                portMissing("ItemParse_columns", source: "oracle/codemp/ui/ui_shared.c:8149")
                // Port-note: A read of `listPtr`, a local the draft left as a hole.
                // Raven wrote: listPtr->columnInfo[i].width = width
                portMissing("ItemParse_columns", source: "oracle/codemp/ui/ui_shared.c:8149")
                // Port-note: A read of `listPtr`, a local the draft left as a hole.
                // Raven wrote: listPtr->columnInfo[i].maxChars = maxChars
                portMissing("ItemParse_columns", source: "oracle/codemp/ui/ui_shared.c:8149")
            } else {
                return false
            }
            i += 1
        }
    } else {
        return false
    }
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8179
func ItemParse_border(_ item: ItemDef, _ handle: Int32) -> Bool {
    if !PC_Int_Parse(handle, &item.window.border) {
        return false
    }
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8186
func ItemParse_bordersize(_ item: ItemDef, _ handle: Int32) -> Bool {
    if !PC_Float_Parse(handle, &item.window.borderSize) {
        return false
    }
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8193
func ItemParse_visible(_ item: ItemDef, _ handle: Int32) -> Bool {
    var i: Int32 = 0

    if !PC_Int_Parse(handle, &i) {
        return false
    }
    if i != 0 {
        item.window.flags |= WINDOW_VISIBLE
    }
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8205
func ItemParse_ownerdraw(_ item: ItemDef, _ handle: Int32) -> Bool {
    if !PC_Int_Parse(handle, &item.window.ownerDraw) {
        return false
    }
    item.type = ITEM_TYPE_OWNERDRAW
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8213
func ItemParse_align(_ item: ItemDef, _ handle: Int32) -> Bool {
    if !PC_Int_Parse(handle, &item.alignment) {
        return false
    }
    return true
}

/**
```
===============
ItemParse_isCharacter

Sets item flag showing this is a character
===============
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:8227
func ItemParse_isCharacter(_ item: ItemDef, _ handle: Int32) -> Bool {
    var flag: Int32 = 0

    if PC_Int_Parse(handle, &flag) {
        if flag != 0 {
            item.flags |= ITF_ISCHARACTER
        } else {
            item.flags &= ~ITF_ISCHARACTER
        }
        return true
    }
    return false
}

/**
```
===============
ItemParse_textalign
===============
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:8252
func ItemParse_textalign(_ item: ItemDef, _ handle: Int32) -> Bool {
    if !PC_Int_Parse(handle, &item.textalignment) {
        Com_Printf(S_COLOR_YELLOW + "Unknown text alignment value")

        return false
    }

    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8264
func ItemParse_textalignx(_ item: ItemDef, _ handle: Int32) -> Bool {
    if !PC_Float_Parse(handle, &item.textalignx) {
        return false
    }
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8271
func ItemParse_textaligny(_ item: ItemDef, _ handle: Int32) -> Bool {
    if !PC_Float_Parse(handle, &item.textaligny) {
        return false
    }
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8278
func ItemParse_textscale(_ item: ItemDef, _ handle: Int32) -> Bool {
    if !PC_Float_Parse(handle, &item.textscale) {
        return false
    }
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8285
func ItemParse_textstyle(_ item: ItemDef, _ handle: Int32) -> Bool {
    if !PC_Int_Parse(handle, &item.textStyle) {
        return false
    }
    return true
}

/**
```
===============
ItemParse_invertyesno
===============
```
*/
//JLFYESNO MPMOVED
/// Source: oracle/codemp/ui/ui_shared.c:8298
func ItemParse_invertyesno(_ item: ItemDef, _ handle: Int32) -> Bool {
    if !PC_Int_Parse(handle, &item.invertYesNo) {
        return false
    }
    return true
}

/**
```
===============
ItemParse_xoffset (used for yes/no and multi)
===============
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:8312
func ItemParse_xoffset(_ item: ItemDef, _ handle: Int32) -> Bool {
    if PC_Int_Parse(handle, &item.xoffset) {
        return false
    }
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8322
func ItemParse_backcolor(_ item: ItemDef, _ handle: Int32) -> Bool {
    var i: Int32
    var f: Float = 0

    i = 0
    while i < 4 {
        if !PC_Float_Parse(handle, &f) {
            return false
        }
        item.window.backColor[Int(i)] = f
        i += 1
    }
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8335
func ItemParse_forecolor(_ item: ItemDef, _ handle: Int32) -> Bool {
    var i: Int32
    var f: Float = 0

    i = 0
    while i < 4 {
        if !PC_Float_Parse(handle, &f) {
            return false
        }

        if f < 0 {
            //special case for player color
            item.window.flags |= WINDOW_PLAYERCOLOR
            return true
        }

        item.window.foreColor[Int(i)] = f
        item.window.flags |= WINDOW_FORECOLORSET
        i += 1
    }
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8356
func ItemParse_bordercolor(_ item: ItemDef, _ handle: Int32) -> Bool {
    var i: Int32
    var f: Float = 0

    i = 0
    while i < 4 {
        if !PC_Float_Parse(handle, &f) {
            return false
        }
        item.window.borderColor[Int(i)] = f
        i += 1
    }
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8369
func ItemParse_outlinecolor(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Slots<Float>' to expected argument type 'vec4_t' (aka 'SIMD4<Float>')".
    // Raven wrote: if (!PC_Color_Parse(handle, &item->window.outlineColor)){ return qfalse; }
    portMissing("ItemParse_outlinecolor", source: "oracle/codemp/ui/ui_shared.c:8369")
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8376
func ItemParse_background(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return PcToken.scratch { token -> Bool in

        if trap_PC_ReadToken(handle, token) == 0 {
            return false
        }
        item.window.background = DC!.runRegisterShaderNoMip(token.string)
        return true
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:8386
func ItemParse_cinematic(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'String?' must be unwrapped to a value of type 'String'".
    // Raven wrote: if (!PC_String_Parse(handle, &item->window.cinematicName)) { return qfalse; }
    portMissing("ItemParse_cinematic", source: "oracle/codemp/ui/ui_shared.c:8386")
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8393
func ItemParse_doubleClick(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: A pointer local `listBoxDef_t * listPtr` with no view.
    // Raven wrote: listBoxDef_t *listPtr;
    portMissing("ItemParse_doubleClick", source: "oracle/codemp/ui/ui_shared.c:8393")

    Item_ValidateTypeData(item)
    if item.typeData == nil {
        return false
    }

    // Port-note: A store into `listPtr`, a local the draft left as a hole.
    // Raven wrote: listPtr = (listBoxDef_t*)item->typeData
    portMissing("ItemParse_doubleClick", source: "oracle/codemp/ui/ui_shared.c:8393")

    // Port-note: A read of `listPtr`, a local the draft left as a hole.
    // Raven wrote: if (!PC_Script_Parse(handle, &listPtr->doubleClick)) { return qfalse; }
    portMissing("ItemParse_doubleClick", source: "oracle/codemp/ui/ui_shared.c:8393")
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8409
func ItemParse_onFocus(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'String?' to expected argument type 'TextCursor'".
    // Raven wrote: if (!PC_Script_Parse(handle, &item->onFocus)) { return qfalse; }
    portMissing("ItemParse_onFocus", source: "oracle/codemp/ui/ui_shared.c:8409")
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8416
func ItemParse_leaveFocus(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'String?' to expected argument type 'TextCursor'".
    // Raven wrote: if (!PC_Script_Parse(handle, &item->leaveFocus)) { return qfalse; }
    portMissing("ItemParse_leaveFocus", source: "oracle/codemp/ui/ui_shared.c:8416")
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8423
func ItemParse_mouseEnter(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'String?' to expected argument type 'TextCursor'".
    // Raven wrote: if (!PC_Script_Parse(handle, &item->mouseEnter)) { return qfalse; }
    portMissing("ItemParse_mouseEnter", source: "oracle/codemp/ui/ui_shared.c:8423")
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8430
func ItemParse_mouseExit(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'String?' to expected argument type 'TextCursor'".
    // Raven wrote: if (!PC_Script_Parse(handle, &item->mouseExit)) { return qfalse; }
    portMissing("ItemParse_mouseExit", source: "oracle/codemp/ui/ui_shared.c:8430")
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8437
func ItemParse_mouseEnterText(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'String?' to expected argument type 'TextCursor'".
    // Raven wrote: if (!PC_Script_Parse(handle, &item->mouseEnterText)) { return qfalse; }
    portMissing("ItemParse_mouseEnterText", source: "oracle/codemp/ui/ui_shared.c:8437")
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8444
func ItemParse_mouseExitText(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'String?' to expected argument type 'TextCursor'".
    // Raven wrote: if (!PC_Script_Parse(handle, &item->mouseExitText)) { return qfalse; }
    portMissing("ItemParse_mouseExitText", source: "oracle/codemp/ui/ui_shared.c:8444")
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8451
func ItemParse_action(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'String?' to expected argument type 'TextCursor'".
    // Raven wrote: if (!PC_Script_Parse(handle, &item->action)) { return qfalse; }
    portMissing("ItemParse_action", source: "oracle/codemp/ui/ui_shared.c:8451")
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8458
func ItemParse_special(_ item: ItemDef, _ handle: Int32) -> Bool {
    if !PC_Float_Parse(handle, &item.special) {
        return false
    }
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8465
func ItemParse_cvarTest(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'String?' must be unwrapped to a value of type 'String'".
    // Raven wrote: if (!PC_String_Parse(handle, &item->cvarTest)) { return qfalse; }
    portMissing("ItemParse_cvarTest", source: "oracle/codemp/ui/ui_shared.c:8465")
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8472
func ItemParse_cvar(_ item: ItemDef, _ handle: Int32) -> Bool {
    Item_ValidateTypeData(item)
    // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'String?' must be unwrapped to a value of type 'String'".
    // Raven wrote: if (!PC_String_Parse(handle, &item->cvar)) { return qfalse; }
    portMissing("ItemParse_cvar", source: "oracle/codemp/ui/ui_shared.c:8472")

    if item.typeData != nil {
        // Port-note: A pointer local `editFieldDef_t * editPtr` with no view.
        // Raven wrote: editFieldDef_t *editPtr;
        portMissing("ItemParse_cvar", source: "oracle/codemp/ui/ui_shared.c:8472")

        switch item.type {
        case ITEM_TYPE_EDITFIELD, ITEM_TYPE_NUMERICFIELD, ITEM_TYPE_YESNO, ITEM_TYPE_BIND, ITEM_TYPE_SLIDER, ITEM_TYPE_TEXT:
            // Port-note: A store into `editPtr`, a local the draft left as a hole.
            // Raven wrote: editPtr = (editFieldDef_t*)item->typeData
            portMissing("ItemParse_cvar", source: "oracle/codemp/ui/ui_shared.c:8472")
            // Port-note: A read of `editPtr`, a local the draft left as a hole.
            // Raven wrote: editPtr->minVal = -1
            portMissing("ItemParse_cvar", source: "oracle/codemp/ui/ui_shared.c:8472")
            // Port-note: A read of `editPtr`, a local the draft left as a hole.
            // Raven wrote: editPtr->maxVal = -1
            portMissing("ItemParse_cvar", source: "oracle/codemp/ui/ui_shared.c:8472")
            // Port-note: A read of `editPtr`, a local the draft left as a hole.
            // Raven wrote: editPtr->defVal = -1
            portMissing("ItemParse_cvar", source: "oracle/codemp/ui/ui_shared.c:8472")

        default:
            break
        }
    }
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8502
func ItemParse_font(_ item: ItemDef, _ handle: Int32) -> Bool {
    Item_ValidateTypeData(item)
    if !PC_Int_Parse(handle, &item.iMenuFont) {
        return false
    }
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8513
func ItemParse_maxChars(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: A pointer local `editFieldDef_t * editPtr` with no view.
    // Raven wrote: editFieldDef_t *editPtr;
    portMissing("ItemParse_maxChars", source: "oracle/codemp/ui/ui_shared.c:8513")
    var maxChars: Int32 = 0

    Item_ValidateTypeData(item)
    if item.typeData == nil {
        return false
    }

    if !PC_Int_Parse(handle, &maxChars) {
        return false
    }
    // Port-note: A store into `editPtr`, a local the draft left as a hole.
    // Raven wrote: editPtr = (editFieldDef_t*)item->typeData
    portMissing("ItemParse_maxChars", source: "oracle/codemp/ui/ui_shared.c:8513")
    // Port-note: A read of `editPtr`, a local the draft left as a hole.
    // Raven wrote: editPtr->maxChars = maxChars
    portMissing("ItemParse_maxChars", source: "oracle/codemp/ui/ui_shared.c:8513")
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8529
func ItemParse_maxPaintChars(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: A pointer local `editFieldDef_t * editPtr` with no view.
    // Raven wrote: editFieldDef_t *editPtr;
    portMissing("ItemParse_maxPaintChars", source: "oracle/codemp/ui/ui_shared.c:8529")
    var maxChars: Int32 = 0

    Item_ValidateTypeData(item)
    if item.typeData == nil {
        return false
    }

    if !PC_Int_Parse(handle, &maxChars) {
        return false
    }
    // Port-note: A store into `editPtr`, a local the draft left as a hole.
    // Raven wrote: editPtr = (editFieldDef_t*)item->typeData
    portMissing("ItemParse_maxPaintChars", source: "oracle/codemp/ui/ui_shared.c:8529")
    // Port-note: A read of `editPtr`, a local the draft left as a hole.
    // Raven wrote: editPtr->maxPaintChars = maxChars
    portMissing("ItemParse_maxPaintChars", source: "oracle/codemp/ui/ui_shared.c:8529")
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8545
func ItemParse_maxLineChars(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: A pointer local `textScrollDef_t * scrollPtr` with no view.
    // Raven wrote: textScrollDef_t *scrollPtr;
    portMissing("ItemParse_maxLineChars", source: "oracle/codemp/ui/ui_shared.c:8545")
    var maxChars: Int32 = 0

    Item_ValidateTypeData(item)
    if item.typeData == nil {
        return false
    }

    if !PC_Int_Parse(handle, &maxChars) {
        return false
    }

    // Port-note: A store into `scrollPtr`, a local the draft left as a hole.
    // Raven wrote: scrollPtr = (textScrollDef_t*)item->typeData
    portMissing("ItemParse_maxLineChars", source: "oracle/codemp/ui/ui_shared.c:8545")
    // Port-note: A read of `scrollPtr`, a local the draft left as a hole.
    // Raven wrote: scrollPtr->maxLineChars = maxChars
    portMissing("ItemParse_maxLineChars", source: "oracle/codemp/ui/ui_shared.c:8545")

    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8565
func ItemParse_lineHeight(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: A pointer local `textScrollDef_t * scrollPtr` with no view.
    // Raven wrote: textScrollDef_t *scrollPtr;
    portMissing("ItemParse_lineHeight", source: "oracle/codemp/ui/ui_shared.c:8565")
    var height: Int32 = 0

    Item_ValidateTypeData(item)
    if item.typeData == nil {
        return false
    }

    if !PC_Int_Parse(handle, &height) {
        return false
    }

    // Port-note: A store into `scrollPtr`, a local the draft left as a hole.
    // Raven wrote: scrollPtr = (textScrollDef_t*)item->typeData
    portMissing("ItemParse_lineHeight", source: "oracle/codemp/ui/ui_shared.c:8565")
    // Port-note: A read of `scrollPtr`, a local the draft left as a hole.
    // Raven wrote: scrollPtr->lineHeight = height
    portMissing("ItemParse_lineHeight", source: "oracle/codemp/ui/ui_shared.c:8565")

    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8585
func ItemParse_cvarFloat(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: A pointer local `editFieldDef_t * editPtr` with no view.
    // Raven wrote: editFieldDef_t *editPtr;
    portMissing("ItemParse_cvarFloat", source: "oracle/codemp/ui/ui_shared.c:8585")

    Item_ValidateTypeData(item)
    if item.typeData == nil {
        return false
    }
    // Port-note: A store into `editPtr`, a local the draft left as a hole.
    // Raven wrote: editPtr = (editFieldDef_t*)item->typeData
    portMissing("ItemParse_cvarFloat", source: "oracle/codemp/ui/ui_shared.c:8585")
    // Port-note: A read of `editPtr`, a local the draft left as a hole.
    // Raven wrote: if (PC_String_Parse(handle, &item->cvar) && PC_Float_Parse(handle, &editPtr->defVal) && PC_Float_Parse(handle, &editPtr->minVal) && PC_Float_Parse(handle, &editPtr->maxVal)) { return qtrue; }
    portMissing("ItemParse_cvarFloat", source: "oracle/codemp/ui/ui_shared.c:8585")
    return false
}

/// Source: oracle/codemp/ui/ui_shared.c:8604
func ItemParse_cvarStrList(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return PcToken.scratch { token -> Bool in
        // Port-note: A pointer local `multiDef_t * multiPtr` with no view.
        // Raven wrote: multiDef_t *multiPtr;
        portMissing("ItemParse_cvarStrList", source: "oracle/codemp/ui/ui_shared.c:8604")
        var pass: Int32 = 0

        Item_ValidateTypeData(item)
        if item.typeData == nil {
            return false
        }
        // Port-note: A store into `multiPtr`, a local the draft left as a hole.
        // Raven wrote: multiPtr = (multiDef_t*)item->typeData
        portMissing("ItemParse_cvarStrList", source: "oracle/codemp/ui/ui_shared.c:8604")
        // Port-note: A read of `multiPtr`, a local the draft left as a hole.
        // Raven wrote: multiPtr->count = 0
        portMissing("ItemParse_cvarStrList", source: "oracle/codemp/ui/ui_shared.c:8604")
        // Port-note: A read of `multiPtr`, a local the draft left as a hole.
        // Raven wrote: multiPtr->strDef = qtrue
        portMissing("ItemParse_cvarStrList", source: "oracle/codemp/ui/ui_shared.c:8604")

        if trap_PC_ReadToken(handle, token) == 0 {
            return false
        }

        if Q_stricmp(token.string, "feeder") == 0 && item.special == FEEDER_PLAYER_SPECIES {
            return true
        }
        // languages
        if Q_stricmp(token.string, "feeder") == 0 && item.special == FEEDER_LANGUAGES {
            // The displayed text
            // The cvar value that goes into se_language
            return true
        }

        // Port-note: A pointer dereference the draft cannot place.
        // Raven wrote: if (*token.string != '{') { return qfalse; }
        portMissing("ItemParse_cvarStrList", source: "oracle/codemp/ui/ui_shared.c:8604")

        pass = 0
        while 1 != 0 {
            // Port-note: A pointer local `char * psString` with no view.
            // Raven wrote: char* psString;
            portMissing("ItemParse_cvarStrList", source: "oracle/codemp/ui/ui_shared.c:8604")

            //		if (!trap_PC_ReadToken(handle, &token)) {
            //			PC_SourceError(handle, "end of file inside menu item\n");
            //			return qfalse;
            //		}

            // Port-note: A cast to `const char **` the draft has no view for.
            // Raven wrote: if (!PC_String_Parse(handle, (const char **)&psString)) { PC_SourceError(handle, "end of file inside menu item\n"); return qfalse; }
            portMissing("ItemParse_cvarStrList", source: "oracle/codemp/ui/ui_shared.c:8604")

            //a normal StringAlloc ptr
            // Port-note: A read of `psString`, a local the draft left as a hole.
            // Raven wrote: if ((int)psString > 0) { if (*psString == '}') { return qtrue; } if (*psString == ',' || *psString == ';') { continue; } }
            portMissing("ItemParse_cvarStrList", source: "oracle/codemp/ui/ui_shared.c:8604")

            if pass == 0 {
                // Port-note: A read of `multiPtr`, a local the draft left as a hole.
                // Raven wrote: multiPtr->cvarList[multiPtr->count] = psString
                portMissing("ItemParse_cvarStrList", source: "oracle/codemp/ui/ui_shared.c:8604")
                pass = 1
            } else {
                // Port-note: A read of `multiPtr`, a local the draft left as a hole.
                // Raven wrote: multiPtr->cvarStr[multiPtr->count] = psString
                portMissing("ItemParse_cvarStrList", source: "oracle/codemp/ui/ui_shared.c:8604")
                pass = 0
                // Port-note: A read of `multiPtr`, a local the draft left as a hole.
                // Raven wrote: multiPtr->count++
                portMissing("ItemParse_cvarStrList", source: "oracle/codemp/ui/ui_shared.c:8604")
                // Port-note: A read of `multiPtr`, a local the draft left as a hole.
                // Raven wrote: if (multiPtr->count >= MAX_MULTI_CVARS) { return qfalse; }
                portMissing("ItemParse_cvarStrList", source: "oracle/codemp/ui/ui_shared.c:8604")
            }
        }
        return false // bk001205 - LCC missing return value
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:8696
func ItemParse_cvarFloatList(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return PcToken.scratch { token -> Bool in
        // Port-note: A pointer local `multiDef_t * multiPtr` with no view.
        // Raven wrote: multiDef_t *multiPtr;
        portMissing("ItemParse_cvarFloatList", source: "oracle/codemp/ui/ui_shared.c:8696")

        Item_ValidateTypeData(item)
        if item.typeData == nil {
            return false
        }

        // Port-note: A store into `multiPtr`, a local the draft left as a hole.
        // Raven wrote: multiPtr = (multiDef_t*)item->typeData
        portMissing("ItemParse_cvarFloatList", source: "oracle/codemp/ui/ui_shared.c:8696")
        // Port-note: A read of `multiPtr`, a local the draft left as a hole.
        // Raven wrote: multiPtr->count = 0
        portMissing("ItemParse_cvarFloatList", source: "oracle/codemp/ui/ui_shared.c:8696")
        // Port-note: A read of `multiPtr`, a local the draft left as a hole.
        // Raven wrote: multiPtr->strDef = qfalse
        portMissing("ItemParse_cvarFloatList", source: "oracle/codemp/ui/ui_shared.c:8696")

        if trap_PC_ReadToken(handle, token) == 0 {
            return false
        }

        // Port-note: A pointer dereference the draft cannot place.
        // Raven wrote: if (*token.string != '{') { return qfalse; }
        portMissing("ItemParse_cvarFloatList", source: "oracle/codemp/ui/ui_shared.c:8696")

        while 1 != 0 {
            // Port-note: A pointer local `char * string` with no view.
            // Raven wrote: char* string;
            portMissing("ItemParse_cvarFloatList", source: "oracle/codemp/ui/ui_shared.c:8696")

            // Port-note: A cast to `const char **` the draft has no view for.
            // Raven wrote: if ( !PC_String_Parse ( handle, (const char **)&string ) ) { PC_SourceError(handle, "end of file inside menu item\n"); return qfalse; }
            portMissing("ItemParse_cvarFloatList", source: "oracle/codemp/ui/ui_shared.c:8696")

            //a normal StringAlloc ptr
            // Port-note: A read of `string`, a local the draft left as a hole.
            // Raven wrote: if ((int)string > 0) { if (*string == '}') { return qtrue; } if (*string == ',' || *string == ';') { continue; } }
            portMissing("ItemParse_cvarFloatList", source: "oracle/codemp/ui/ui_shared.c:8696")

            // Port-note: A read of `multiPtr`, a local the draft left as a hole.
            // Raven wrote: multiPtr->cvarList[multiPtr->count] = string
            portMissing("ItemParse_cvarFloatList", source: "oracle/codemp/ui/ui_shared.c:8696")
            // Port-note: A read of `multiPtr`, a local the draft left as a hole.
            // Raven wrote: if (!PC_Float_Parse(handle, &multiPtr->cvarValue[multiPtr->count])) { return qfalse; }
            portMissing("ItemParse_cvarFloatList", source: "oracle/codemp/ui/ui_shared.c:8696")

            // Port-note: A read of `multiPtr`, a local the draft left as a hole.
            // Raven wrote: multiPtr->count++
            portMissing("ItemParse_cvarFloatList", source: "oracle/codemp/ui/ui_shared.c:8696")
            // Port-note: A read of `multiPtr`, a local the draft left as a hole.
            // Raven wrote: if (multiPtr->count >= MAX_MULTI_CVARS) { return qfalse; }
            portMissing("ItemParse_cvarFloatList", source: "oracle/codemp/ui/ui_shared.c:8696")
        }
        return false // bk001205 - LCC missing return value
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:8763
func ItemParse_addColorRange(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return ColorRangeDef.scratch { color -> Bool in

        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Slots<Float>' to expected argument type 'vec4_t' (aka 'SIMD4<Float>')".
        // Raven wrote: if (PC_Float_Parse(handle, &color.low) && PC_Float_Parse(handle, &color.high) && PC_Color_Parse(handle, &color.color) ) { if (item->numColors < MAX_COLOR_RANGES) { memcpy(&item->colorRanges[item->numColors], &color, sizeof(color)); item->numColors++; } return qtrue; }
        portMissing("ItemParse_addColorRange", source: "oracle/codemp/ui/ui_shared.c:8763")
        return false
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:8778
func ItemParse_ownerdrawFlag(_ item: ItemDef, _ handle: Int32) -> Bool {
    var i: Int32 = 0
    if !PC_Int_Parse(handle, &i) {
        return false
    }
    item.window.ownerDrawFlags |= i
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8787
func ItemParse_enableCvar(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'String?' to expected argument type 'TextCursor'".
    // Raven wrote: if (PC_Script_Parse(handle, &item->enableCvar)) { item->cvarFlags = CVAR_ENABLE; return qtrue; }
    portMissing("ItemParse_enableCvar", source: "oracle/codemp/ui/ui_shared.c:8787")
    return false
}

/// Source: oracle/codemp/ui/ui_shared.c:8795
func ItemParse_disableCvar(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'String?' to expected argument type 'TextCursor'".
    // Raven wrote: if (PC_Script_Parse(handle, &item->enableCvar)) { item->cvarFlags = CVAR_DISABLE; return qtrue; }
    portMissing("ItemParse_disableCvar", source: "oracle/codemp/ui/ui_shared.c:8795")
    return false
}

/// Source: oracle/codemp/ui/ui_shared.c:8803
func ItemParse_showCvar(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'String?' to expected argument type 'TextCursor'".
    // Raven wrote: if (PC_Script_Parse(handle, &item->enableCvar)) { item->cvarFlags = CVAR_SHOW; return qtrue; }
    portMissing("ItemParse_showCvar", source: "oracle/codemp/ui/ui_shared.c:8803")
    return false
}

/// Source: oracle/codemp/ui/ui_shared.c:8811
func ItemParse_hideCvar(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'String?' to expected argument type 'TextCursor'".
    // Raven wrote: if (PC_Script_Parse(handle, &item->enableCvar)) { item->cvarFlags = CVAR_HIDE; return qtrue; }
    portMissing("ItemParse_hideCvar", source: "oracle/codemp/ui/ui_shared.c:8811")
    return false
}

/**
```
===============
ItemParse_align
===============
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:8824
func ItemParse_Appearance_slot(_ item: ItemDef, _ handle: Int32) -> Bool {
    if !PC_Int_Parse(handle, &item.appearanceSlot) {
        return false
    }
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:8833
func ItemParse_isSaber(_ item: ItemDef, _ handle: Int32) -> Bool {
    return false
}

/// Source: oracle/codemp/ui/ui_shared.c:8865
func ItemParse_isSaber2(_ item: ItemDef, _ handle: Int32) -> Bool {
    return false
}

/**
```
===============
Item_SetupKeywordHash
===============
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:8995
func Item_SetupKeywordHash() {
    var i: Int32

    // Port-note: Raven's `memset(itemParseKeywordHash, 0, sizeof(itemParseKeywordHash))` runs over bytes that are not one record with a view.
    // Raven wrote: memset(itemParseKeywordHash, 0, sizeof(itemParseKeywordHash))
    portMissing("Item_SetupKeywordHash", source: "oracle/codemp/ui/ui_shared.c:8995")
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'itemParseKeywords' in scope".
    // Raven wrote: for (i = 0; itemParseKeywords[i].keyword; i++) { KeywordHash_Add(itemParseKeywordHash, &itemParseKeywords[i]); }
    portMissing("Item_SetupKeywordHash", source: "oracle/codemp/ui/ui_shared.c:8995")
}

/**
```
===============
Item_Parse
===============
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:9009
func Item_Parse(_ handle: Int32, _ item: ItemDef) -> Bool {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return PcToken.scratch { token -> Bool in
        // Port-note: A pointer local `keywordHash_t * key` with no view.
        // Raven wrote: keywordHash_t *key;
        portMissing("Item_Parse", source: "oracle/codemp/ui/ui_shared.c:9009")


        if trap_PC_ReadToken(handle, token) == 0 {
            return false
        }
        // Port-note: A pointer dereference the draft cannot place.
        // Raven wrote: if (*token.string != '{') { return qfalse; }
        portMissing("Item_Parse", source: "oracle/codemp/ui/ui_shared.c:9009")
        while 1 != 0 {
            if trap_PC_ReadToken(handle, token) == 0 {
                // Port-note: Raven passes `"end of file inside menu item\n"` to `PC_SourceError`, whose `char *` parameter the stub holds as an inout CharBuf. Docket row 5 is due.
                // Raven wrote: PC_SourceError(handle, "end of file inside menu item\n")
                portMissing("Item_Parse", source: "oracle/codemp/ui/ui_shared.c:9009")
                return false
            }

            // Port-note: A pointer dereference the draft cannot place.
            // Raven wrote: if (*token.string == '}') { return qtrue; }
            portMissing("Item_Parse", source: "oracle/codemp/ui/ui_shared.c:9009")

            // Port-note: A store into `key`, a local the draft left as a hole.
            // Raven wrote: key = KeywordHash_Find(itemParseKeywordHash, token.string)
            portMissing("Item_Parse", source: "oracle/codemp/ui/ui_shared.c:9009")
            // Port-note: A read of `key`, a local the draft left as a hole.
            // Raven wrote: if (!key) { PC_SourceError(handle, "unknown menu item keyword %s", token.string); continue; }
            portMissing("Item_Parse", source: "oracle/codemp/ui/ui_shared.c:9009")
            // Port-note: A read of `key`, a local the draft left as a hole.
            // Raven wrote: if ( !key->func(item, handle) ) { PC_SourceError(handle, "couldn't parse menu item keyword %s", token.string); return qfalse; }
            portMissing("Item_Parse", source: "oracle/codemp/ui/ui_shared.c:9009")
        }
        return false // bk001205 - LCC missing return value
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:9042
private func Item_TextScroll_BuildLines(_ item: ItemDef) {
    var text = CharBuf(2048)


    // new asian-aware line breaker...  (pasted from elsewhere late @ night, hence aliasing-vars ;-)
    //
    // Port-note: A pointer local `textScrollDef_t * scrollPtr` with no view.
    // Raven wrote: textScrollDef_t* scrollPtr = (textScrollDef_t*) item->typeData;
    portMissing("Item_TextScroll_BuildLines", source: "oracle/codemp/ui/ui_shared.c:9042")
    // Port-note: A pointer local `const char * psText` with no view.
    // Raven wrote: const char *psText = item->text;
    portMissing("Item_TextScroll_BuildLines", source: "oracle/codemp/ui/ui_shared.c:9042")
    let iBoxWidth: Int32 = Int32(Double(item.window.rect.w) - SCROLLBAR_SIZE - 10)

    // this could probably be simplified now, but it was converted from something else I didn't originally write,
    //	and it works anyway so wtf...
    //
    // Port-note: A pointer local `const char * psCurrentTextReadPos` with no view.
    // Raven wrote: const char *psCurrentTextReadPos;
    portMissing("Item_TextScroll_BuildLines", source: "oracle/codemp/ui/ui_shared.c:9042")
    // Port-note: A pointer local `const char * psReadPosAtLineStart` with no view.
    // Raven wrote: const char *psReadPosAtLineStart;
    portMissing("Item_TextScroll_BuildLines", source: "oracle/codemp/ui/ui_shared.c:9042")
    // Port-note: A pointer local `const char * psBestLineBreakSrcPos` with no view.
    // Raven wrote: const char *psBestLineBreakSrcPos;
    portMissing("Item_TextScroll_BuildLines", source: "oracle/codemp/ui/ui_shared.c:9042")
    // Port-note: A pointer local `const char * psLastGood_s` with no view.
    // Raven wrote: const char *psLastGood_s;
    portMissing("Item_TextScroll_BuildLines", source: "oracle/codemp/ui/ui_shared.c:9042")
    var bIsTrailingPunctuation: Bool = false
    var uiLetter: UInt32

    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: if (*psText == '@') // string reference { trap_SP_GetStringTextString( &psText[1], text, sizeof(text)); psText = text; }
    portMissing("Item_TextScroll_BuildLines", source: "oracle/codemp/ui/ui_shared.c:9042")

    // Port-note: A store into `psCurrentTextReadPos`, a local the draft left as a hole.
    // Raven wrote: psCurrentTextReadPos = psText
    portMissing("Item_TextScroll_BuildLines", source: "oracle/codemp/ui/ui_shared.c:9042")
    // Port-note: A store into `psReadPosAtLineStart`, a local the draft left as a hole.
    // Raven wrote: psReadPosAtLineStart = psCurrentTextReadPos
    portMissing("Item_TextScroll_BuildLines", source: "oracle/codemp/ui/ui_shared.c:9042")
    // Port-note: A store into `psBestLineBreakSrcPos`, a local the draft left as a hole.
    // Raven wrote: psBestLineBreakSrcPos = psCurrentTextReadPos
    portMissing("Item_TextScroll_BuildLines", source: "oracle/codemp/ui/ui_shared.c:9042")

    // Port-note: A read of `scrollPtr`, a local the draft left as a hole.
    // Raven wrote: scrollPtr->iLineCount = 0
    portMissing("Item_TextScroll_BuildLines", source: "oracle/codemp/ui/ui_shared.c:9042")
    // Port-note: Raven's `memset((char*)scrollPtr->pLines,0,sizeof(scrollPtr->pLines))` runs over bytes that are not one record with a view.
    // Raven wrote: memset((char*)scrollPtr->pLines,0,sizeof(scrollPtr->pLines))
    portMissing("Item_TextScroll_BuildLines", source: "oracle/codemp/ui/ui_shared.c:9042")

    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: while (*psCurrentTextReadPos && (scrollPtr->iLineCount < MAX_TEXTSCROLL_LINES) ) { char sLineForDisplay[2048]; // ott // construct a line... // psCurrentTextReadPos = psReadPosAtLineStart; sLineForDisplay[0] = '\0'; while ( *psCurrentTextReadPos ) { int iAdvanceCount; psLastGood_s = psCurrentTextReadPos; // read letter... // uiLetter = trap_AnyLanguage_ReadCharFromString(psCurrentTextReadPos, &iAdvanceCount, &bIsTrailingPunctuation); psCurrentTextReadPos += iAdvanceCount; // concat onto string so far... // if (uiLetter == 32 && sLineForDisplay[0] == '\0') { psReadPosAtLineStart++; continue; // unless it's a space at the start of a line, in which case ignore it. } if (uiLetter > 255) { Q_strcat(sLineForDisplay, sizeof(sLineForDisplay),va("%c%c",uiLetter >> 8, uiLetter & 0xFF)); } else { Q_strcat(sLineForDisplay, sizeof(sLineForDisplay),va("%c",uiLetter & 0xFF)); } if (uiLetter == '\n') { // explicit new line... // sLineForDisplay[ strlen(sLineForDisplay)-1 ] = '\0'; // kill the CR psReadPosAtLineStart = psCurrentTextReadPos; psBestLineBreakSrcPos = psCurrentTextReadPos; // hack it to fit in with this code... // scrollPtr->pLines[ scrollPtr->iLineCount ] = String_Alloc ( sLineForDisplay ); break; // print this line } else if ( DC->textWidth( sLineForDisplay, item->textscale, item->iMenuFont ) >= iBoxWidth ) { // reached screen edge, so cap off string at bytepos after last good position... // if (uiLetter > 255 && bIsTrailingPunctuation && !trap_Language_UsesSpaces()) { // Special case, don't consider line breaking if you're on an asian punctuation char of // a language that doesn't use spaces... // uiLetter = uiLetter; // breakpoint line only } else { if (psBestLineBreakSrcPos == psReadPosAtLineStart) { // aarrrggh!!!!! we'll only get here is someone has fed in a (probably) garbage string, // since it doesn't have a single space or punctuation mark right the way across one line // of the screen. So far, this has only happened in testing when I hardwired a taiwanese // string into this function while the game was running in english (which should NEVER happen // normally). On the other hand I suppose it's entirely possible that some taiwanese string // might have no punctuation at all, so... // psBestLineBreakSrcPos = psLastGood_s; // force a break after last good letter } sLineForDisplay[ psBestLineBreakSrcPos - psReadPosAtLineStart ] = '\0'; psReadPosAtLineStart = psCurrentTextReadPos = psBestLineBreakSrcPos; // hack it to fit in with this code... // scrollPtr->pLines[ scrollPtr->iLineCount ] = String_Alloc( sLineForDisplay ); break; // print this line } } // record last-good linebreak pos... (ie if we've just concat'd a punctuation point (western or asian) or space) // if (bIsTrailingPunctuation || uiLetter == ' ' || (uiLetter > 255 && !trap_Language_UsesSpaces())) { psBestLineBreakSrcPos = psCurrentTextReadPos; } } /// arrgghh, this is gettng horrible now... // if (scrollPtr->pLines[ scrollPtr->iLineCount ] == NULL && strlen(sLineForDisplay)) { // then this is the last line and we've just run out of text, no CR, no overflow etc... // scrollPtr->pLines[ scrollPtr->iLineCount ] = String_Alloc( sLineForDisplay ); } scrollPtr->iLineCount++; }
    portMissing("Item_TextScroll_BuildLines", source: "oracle/codemp/ui/ui_shared.c:9042")

    // old version...
    //



    // Keep going as long as there are more lines
    // End of the road


    // Force a line end if its a '\n'

    // Get the current character width

    // Past the end of the boundary?
    // Past the end so backtrack to the word boundary


    // Skip any whitespaces
}

// Item_InitControls
// init's special control types
/// Source: oracle/codemp/ui/ui_shared.c:9259
func Item_InitControls(_ item: ItemDef) {
    if item == nil {
        return
    }

    switch item.type {
    case ITEM_TYPE_LISTBOX:
        do {
            // Port-note: A pointer local `listBoxDef_t * listPtr` with no view.
            // Raven wrote: listBoxDef_t *listPtr = (listBoxDef_t*)item->typeData;
            portMissing("Item_InitControls", source: "oracle/codemp/ui/ui_shared.c:9259")
            item.cursorPos = 0
            // Port-note: A read of `listPtr`, a local the draft left as a hole.
            // Raven wrote: if (listPtr) { listPtr->cursorPos = 0; listPtr->startPos = 0; listPtr->endPos = 0; listPtr->cursorPos = 0; }
            portMissing("Item_InitControls", source: "oracle/codemp/ui/ui_shared.c:9259")

            break
        }

    default:
        break
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:9291
func MenuParse_font(_ item: ItemDef, _ handle: Int32) -> Bool {
    let menu: MenuDef? = MenuDef(item)
    // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'String?' must be unwrapped to a value of type 'String'".
    // Raven wrote: if (!PC_String_Parse(handle, &menu->font)) { return qfalse; }
    portMissing("MenuParse_font", source: "oracle/codemp/ui/ui_shared.c:9291")
    if !DC!.Assets.fontRegistered {
        //DC->registerFont(menu->font, 48, &DC->Assets.textFont);
        DC!.Assets.qhMediumFont = DC!.runRegisterFont(menu!.font!)
        DC!.Assets.fontRegistered = true
    }
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:9304
func MenuParse_name(_ item: ItemDef, _ handle: Int32) -> Bool {
    let menu: MenuDef? = MenuDef(item)
    // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'String?' must be unwrapped to a value of type 'String'".
    // Raven wrote: if (!PC_String_Parse(handle, &menu->window.name)) { return qfalse; }
    portMissing("MenuParse_name", source: "oracle/codemp/ui/ui_shared.c:9304")
    if Q_stricmp(menu!.window.name!, "main") == 0 {
        // default main as having focus
        //menu->window.flags |= WINDOW_HASFOCUS;
    }
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:9316
func MenuParse_fullscreen(_ item: ItemDef, _ handle: Int32) -> Bool {
    let menu: MenuDef? = MenuDef(item)
    // Port-note: A cast to `int *` the draft has no view for.
    // Raven wrote: if (!PC_Int_Parse(handle, (int*) &menu->fullScreen)) { // bk001206 - cast qboolean return qfalse; }
    portMissing("MenuParse_fullscreen", source: "oracle/codemp/ui/ui_shared.c:9316")
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:9324
func MenuParse_rect(_ item: ItemDef, _ handle: Int32) -> Bool {
    let menu: MenuDef? = MenuDef(item)
    if !PC_Rect_Parse(handle, menu!.window.rect) {
        return false
    }
    return true
}

/**
```
=================
MenuParse_style
=================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:9337
func MenuParse_style(_ item: ItemDef, _ handle: Int32) -> Bool {
    let menu: MenuDef? = MenuDef(item)

    if !PC_Int_Parse(handle, &menu!.window.style) {
        Com_Printf(S_COLOR_YELLOW + "Unknown menu style value")
        return false
    }

    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:9350
func MenuParse_visible(_ item: ItemDef, _ handle: Int32) -> Bool {
    var i: Int32 = 0
    let menu: MenuDef? = MenuDef(item)

    if !PC_Int_Parse(handle, &i) {
        return false
    }
    if i != 0 {
        menu!.window.flags |= WINDOW_VISIBLE
    }
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:9363
func MenuParse_onOpen(_ item: ItemDef, _ handle: Int32) -> Bool {
    let menu: MenuDef? = MenuDef(item)
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'String?' to expected argument type 'TextCursor'".
    // Raven wrote: if (!PC_Script_Parse(handle, &menu->onOpen)) { return qfalse; }
    portMissing("MenuParse_onOpen", source: "oracle/codemp/ui/ui_shared.c:9363")
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:9371
func MenuParse_onClose(_ item: ItemDef, _ handle: Int32) -> Bool {
    let menu: MenuDef? = MenuDef(item)
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'String?' to expected argument type 'TextCursor'".
    // Raven wrote: if (!PC_Script_Parse(handle, &menu->onClose)) { return qfalse; }
    portMissing("MenuParse_onClose", source: "oracle/codemp/ui/ui_shared.c:9371")
    return true
}

//JLFACCEPT MPMOVED
/**
```
=================
MenuParse_onAccept
=================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:9385
func MenuParse_onAccept(_ item: ItemDef, _ handle: Int32) -> Bool {
    let menu: MenuDef? = MenuDef(item)

    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'String?' to expected argument type 'TextCursor'".
    // Raven wrote: if (!PC_Script_Parse(handle, &menu->onAccept)) { return qfalse; }
    portMissing("MenuParse_onAccept", source: "oracle/codemp/ui/ui_shared.c:9385")
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:9396
func MenuParse_onESC(_ item: ItemDef, _ handle: Int32) -> Bool {
    let menu: MenuDef? = MenuDef(item)
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'String?' to expected argument type 'TextCursor'".
    // Raven wrote: if (!PC_Script_Parse(handle, &menu->onESC)) { return qfalse; }
    portMissing("MenuParse_onESC", source: "oracle/codemp/ui/ui_shared.c:9396")
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:9406
func MenuParse_border(_ item: ItemDef, _ handle: Int32) -> Bool {
    let menu: MenuDef? = MenuDef(item)
    if !PC_Int_Parse(handle, &menu!.window.border) {
        return false
    }
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:9414
func MenuParse_borderSize(_ item: ItemDef, _ handle: Int32) -> Bool {
    let menu: MenuDef? = MenuDef(item)
    if !PC_Float_Parse(handle, &menu!.window.borderSize) {
        return false
    }
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:9422
func MenuParse_backcolor(_ item: ItemDef, _ handle: Int32) -> Bool {
    var i: Int32
    var f: Float = 0
    let menu: MenuDef? = MenuDef(item)

    i = 0
    while i < 4 {
        if !PC_Float_Parse(handle, &f) {
            return false
        }
        menu!.window.backColor[Int(i)] = f
        i += 1
    }
    return true
}

/**
```
=================
MenuParse_descAlignment
=================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:9441
func MenuParse_descAlignment(_ item: ItemDef, _ handle: Int32) -> Bool {
    let menu: MenuDef? = MenuDef(item)

    if !PC_Int_Parse(handle, &menu!.descAlignment) {
        Com_Printf(S_COLOR_YELLOW + "Unknown desc alignment value")
        return false
    }

    return true
}

/**
```
=================
MenuParse_descX
=================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:9459
func MenuParse_descX(_ item: ItemDef, _ handle: Int32) -> Bool {
    let menu: MenuDef? = MenuDef(item)

    if !PC_Int_Parse(handle, &menu!.descX) {
        return false
    }
    return true
}

/**
```
=================
MenuParse_descY
=================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:9475
func MenuParse_descY(_ item: ItemDef, _ handle: Int32) -> Bool {
    let menu: MenuDef? = MenuDef(item)

    if !PC_Int_Parse(handle, &menu!.descY) {
        return false
    }
    return true
}

/**
```
=================
MenuParse_descScale
=================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:9491
func MenuParse_descScale(_ item: ItemDef, _ handle: Int32) -> Bool {
    let menu: MenuDef? = MenuDef(item)

    if !PC_Float_Parse(handle, &menu!.descScale) {
        return false
    }
    return true
}

/**
```
=================
MenuParse_descColor
=================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:9507
func MenuParse_descColor(_ item: ItemDef, _ handle: Int32) -> Bool {
    var i: Int32
    var f: Float = 0
    let menu: MenuDef? = MenuDef(item)

    i = 0
    while i < 4 {
        if !PC_Float_Parse(handle, &f) {
            return false
        }
        menu!.descColor[Int(i)] = f
        i += 1
    }
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:9524
func MenuParse_forecolor(_ item: ItemDef, _ handle: Int32) -> Bool {
    var i: Int32
    var f: Float = 0
    let menu: MenuDef? = MenuDef(item)

    i = 0
    while i < 4 {
        if !PC_Float_Parse(handle, &f) {
            return false
        }
        if f < 0 {
            //special case for player color
            menu!.window.flags |= WINDOW_PLAYERCOLOR
            return true
        }
        menu!.window.foreColor[Int(i)] = f
        menu!.window.flags |= WINDOW_FORECOLORSET
        i += 1
    }
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:9544
func MenuParse_bordercolor(_ item: ItemDef, _ handle: Int32) -> Bool {
    var i: Int32
    var f: Float = 0
    let menu: MenuDef? = MenuDef(item)

    i = 0
    while i < 4 {
        if !PC_Float_Parse(handle, &f) {
            return false
        }
        menu!.window.borderColor[Int(i)] = f
        i += 1
    }
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:9558
func MenuParse_focuscolor(_ item: ItemDef, _ handle: Int32) -> Bool {
    var i: Int32
    var f: Float = 0
    let menu: MenuDef? = MenuDef(item)

    i = 0
    while i < 4 {
        if !PC_Float_Parse(handle, &f) {
            return false
        }
        menu!.focusColor[Int(i)] = f
        i += 1
    }
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:9572
func MenuParse_disablecolor(_ item: ItemDef, _ handle: Int32) -> Bool {
    var i: Int32
    var f: Float = 0
    let menu: MenuDef? = MenuDef(item)
    i = 0
    while i < 4 {
        if !PC_Float_Parse(handle, &f) {
            return false
        }
        menu!.disableColor[Int(i)] = f
        i += 1
    }
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:9586
func MenuParse_outlinecolor(_ item: ItemDef, _ handle: Int32) -> Bool {
    let menu: MenuDef? = MenuDef(item)
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'Slots<Float>' to expected argument type 'vec4_t' (aka 'SIMD4<Float>')".
    // Raven wrote: if (!PC_Color_Parse(handle, &menu->window.outlineColor)){ return qfalse; }
    portMissing("MenuParse_outlinecolor", source: "oracle/codemp/ui/ui_shared.c:9586")
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:9594
func MenuParse_background(_ item: ItemDef, _ handle: Int32) -> Bool {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return PcToken.scratch { token -> Bool in
        let menu: MenuDef? = MenuDef(item)

        if trap_PC_ReadToken(handle, token) == 0 {
            return false
        }
        menu!.window.background = DC!.runRegisterShaderNoMip(token.string)
        return true
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:9605
func MenuParse_cinematic(_ item: ItemDef, _ handle: Int32) -> Bool {
    let menu: MenuDef? = MenuDef(item)

    // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'String?' must be unwrapped to a value of type 'String'".
    // Raven wrote: if (!PC_String_Parse(handle, &menu->window.cinematicName)) { return qfalse; }
    portMissing("MenuParse_cinematic", source: "oracle/codemp/ui/ui_shared.c:9605")
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:9614
func MenuParse_ownerdrawFlag(_ item: ItemDef, _ handle: Int32) -> Bool {
    var i: Int32 = 0
    let menu: MenuDef? = MenuDef(item)

    if !PC_Int_Parse(handle, &i) {
        return false
    }
    menu!.window.ownerDrawFlags |= i
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:9625
func MenuParse_ownerdraw(_ item: ItemDef, _ handle: Int32) -> Bool {
    let menu: MenuDef? = MenuDef(item)

    if !PC_Int_Parse(handle, &menu!.window.ownerDraw) {
        return false
    }
    return true
}

// decoration
/// Source: oracle/codemp/ui/ui_shared.c:9636
func MenuParse_popup(_ item: ItemDef, _ handle: Int32) -> Bool {
    let menu: MenuDef? = MenuDef(item)
    menu!.window.flags |= WINDOW_POPUP
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:9643
func MenuParse_outOfBounds(_ item: ItemDef, _ handle: Int32) -> Bool {
    let menu: MenuDef? = MenuDef(item)

    menu!.window.flags |= WINDOW_OOB_CLICK
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:9650
func MenuParse_soundLoop(_ item: ItemDef, _ handle: Int32) -> Bool {
    let menu: MenuDef? = MenuDef(item)

    // Port-note: The draft of this statement did not compile, and the compiler wrote "value of optional type 'String?' must be unwrapped to a value of type 'String'".
    // Raven wrote: if (!PC_String_Parse(handle, &menu->soundName)) { return qfalse; }
    portMissing("MenuParse_soundLoop", source: "oracle/codemp/ui/ui_shared.c:9650")
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:9659
func MenuParse_fadeClamp(_ item: ItemDef, _ handle: Int32) -> Bool {
    let menu: MenuDef? = MenuDef(item)

    if !PC_Float_Parse(handle, &menu!.fadeClamp) {
        return false
    }
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:9668
func MenuParse_fadeAmount(_ item: ItemDef, _ handle: Int32) -> Bool {
    let menu: MenuDef? = MenuDef(item)

    if !PC_Float_Parse(handle, &menu!.fadeAmount) {
        return false
    }
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:9678
func MenuParse_fadeCycle(_ item: ItemDef, _ handle: Int32) -> Bool {
    let menu: MenuDef? = MenuDef(item)

    if !PC_Int_Parse(handle, &menu!.fadeCycle) {
        return false
    }
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:9688
func MenuParse_itemDef(_ item: ItemDef, _ handle: Int32) -> Bool {
    let menu: MenuDef? = MenuDef(item)
    if menu!.itemCount < MAX_MENUITEMS {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "argument passed to call that takes no arguments".
        // Raven wrote: menu->items[menu->itemCount] = (itemDef_t *) UI_Alloc(sizeof(itemDef_t))
        portMissing("MenuParse_itemDef", source: "oracle/codemp/ui/ui_shared.c:9688")
        Item_Init(menu!.items[menu!.itemCount]!)
        if !Item_Parse(handle, menu!.items[menu!.itemCount]!) {
            return false
        }
        Item_InitControls(menu!.items[menu!.itemCount]!)
        // Port-note: A ++ inside an expression.
        // Raven wrote: menu->items[menu->itemCount++]->parent = menu
        portMissing("MenuParse_itemDef", source: "oracle/codemp/ui/ui_shared.c:9688")
    }
    return true
}

/**
```
=================
MenuParse_focuscolor
=================
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:9706
func MenuParse_appearanceIncrement(_ item: ItemDef, _ handle: Int32) -> Bool {
    let menu: MenuDef? = MenuDef(item)

    if !PC_Float_Parse(handle, &menu!.appearanceIncrement) {
        return false
    }
    return true
}

/**
```
===============
Menu_SetupKeywordHash
===============
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:9765
func Menu_SetupKeywordHash() {
    var i: Int32

    // Port-note: Raven's `memset(menuParseKeywordHash, 0, sizeof(menuParseKeywordHash))` runs over bytes that are not one record with a view.
    // Raven wrote: memset(menuParseKeywordHash, 0, sizeof(menuParseKeywordHash))
    portMissing("Menu_SetupKeywordHash", source: "oracle/codemp/ui/ui_shared.c:9765")
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'menuParseKeywords' in scope".
    // Raven wrote: for (i = 0; menuParseKeywords[i].keyword; i++) { KeywordHash_Add(menuParseKeywordHash, &menuParseKeywords[i]); }
    portMissing("Menu_SetupKeywordHash", source: "oracle/codemp/ui/ui_shared.c:9765")
}

/**
```
===============
Menu_Parse
===============
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:9779
func Menu_Parse(_ handle: Int32, _ menu: MenuDef) -> Bool {
    // Raven's record lives to the end of his block, so the block is the closure.
    // Every path of Raven's block returns, so the closure's value is the function's.
    return PcToken.scratch { token -> Bool in
        // Port-note: A pointer local `keywordHash_t * key` with no view.
        // Raven wrote: keywordHash_t *key;
        portMissing("Menu_Parse", source: "oracle/codemp/ui/ui_shared.c:9779")

        if trap_PC_ReadToken(handle, token) == 0 {
            return false
        }
        // Port-note: A pointer dereference the draft cannot place.
        // Raven wrote: if (*token.string != '{') { return qfalse; }
        portMissing("Menu_Parse", source: "oracle/codemp/ui/ui_shared.c:9779")

        while 1 != 0 {
            if trap_PC_ReadToken(handle, token) == 0 {
                // Port-note: Raven passes `"end of file inside menu\n"` to `PC_SourceError`, whose `char *` parameter the stub holds as an inout CharBuf. Docket row 5 is due.
                // Raven wrote: PC_SourceError(handle, "end of file inside menu\n")
                portMissing("Menu_Parse", source: "oracle/codemp/ui/ui_shared.c:9779")
                return false
            }

            // Port-note: A pointer dereference the draft cannot place.
            // Raven wrote: if (*token.string == '}') { return qtrue; }
            portMissing("Menu_Parse", source: "oracle/codemp/ui/ui_shared.c:9779")

            // Port-note: A store into `key`, a local the draft left as a hole.
            // Raven wrote: key = KeywordHash_Find(menuParseKeywordHash, token.string)
            portMissing("Menu_Parse", source: "oracle/codemp/ui/ui_shared.c:9779")
            // Port-note: A read of `key`, a local the draft left as a hole.
            // Raven wrote: if (!key) { PC_SourceError(handle, "unknown menu keyword %s", token.string); continue; }
            portMissing("Menu_Parse", source: "oracle/codemp/ui/ui_shared.c:9779")
            // Port-note: A read of `key`, a local the draft left as a hole.
            // Raven wrote: if ( !key->func((itemDef_t*)menu, handle) ) { PC_SourceError(handle, "couldn't parse menu keyword %s", token.string); return qfalse; }
            portMissing("Menu_Parse", source: "oracle/codemp/ui/ui_shared.c:9779")
        }
        return false // bk001205 - LCC missing return value
    }
}

/**
```
===============
Menu_New
===============
```
*/
/// Source: oracle/codemp/ui/ui_shared.c:9817
func Menu_New(_ handle: Int32) {
    let menu: MenuDef? = Menus[menuCount]

    if menuCount < MAX_MENUS {
        Menu_Init(menu!)
        if Menu_Parse(handle, menu!) {
            Menu_PostParse(menu!)
            menuCount += 1
        }
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:9829
func Menu_Count() -> Int32 {
    return menuCount
}

/// Source: oracle/codemp/ui/ui_shared.c:9833
func Menu_PaintAll() {
    var i: Int32
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'captureFunc' in scope".
    // Raven wrote: if (captureFunc) { captureFunc(captureData); }
    portMissing("Menu_PaintAll", source: "oracle/codemp/ui/ui_shared.c:9833")

    i = 0
    while i < Menu_Count() {
        Menu_Paint(Menus[i], false)
        i += 1
    }

    if debugMode {
        var v = vec4_t(1, 1, 1, 1)
        DC!.runDrawText(5, 25, 0.75, &v, va("fps: %f", DC!.FPS), 0, 0, 0, 0)
        DC!.runDrawText(5, 45, 0.75, &v, va("x: %d  y:%d", DC!.cursorx, DC!.cursory), 0, 0, 0, 0)
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:9850
func Menu_Reset() {
    menuCount = 0
}

/// Source: oracle/codemp/ui/ui_shared.c:9854
func Display_GetContext() -> DisplayContextDef? {
    return DC
}

/// Source: oracle/codemp/ui/ui_shared.c:9858
func Display_CaptureItem(_ x: Int32, _ y: Int32) -> MenuDef? {
    // TODO: Port Display_CaptureItem
    portMissing("Display_CaptureItem", source: "oracle/codemp/ui/ui_shared.c:9858")
}

// FIXME:
/// Source: oracle/codemp/ui/ui_shared.c:9873
func Display_MouseMove(_ p: MenuDef?, _ x: Int32, _ y: Int32) -> Bool {
    //JLFMOUSE  AGAIN I THINK THIS SHOULD BE MOOT
    //END JLF
    var i: Int32
    // Port-note: The draft of this statement did not compile, and the compiler wrote "no exact matches in call to initializer".
    // Raven wrote: menuDef_t *menu = (menuDef_t *) p;
    portMissing("Display_MouseMove", source: "oracle/codemp/ui/ui_shared.c:9873")

    // Port-note: A read of `menu`, a local the draft left as a hole.
    // Raven wrote: if (menu == NULL) { menu = Menu_GetFocused(); if (menu) { if (menu->window.flags & WINDOW_POPUP) { Menu_HandleMouseMove(menu, x, y); return qtrue; } } for (i = 0; i < menuCount; i++) { Menu_HandleMouseMove(&Menus[i], x, y); } } else { menu->window.rect.x += x; menu->window.rect.y += y; Menu_UpdatePosition(menu); }
    portMissing("Display_MouseMove", source: "oracle/codemp/ui/ui_shared.c:9873")
    return true
}

/// Source: oracle/codemp/ui/ui_shared.c:9903
func Display_CursorType(_ x: Int32, _ y: Int32) -> Int32 {
    var i: Int32 = 0
    i = 0
    while i < menuCount {
        // Raven's record lives to the end of his block, so the block is the closure.
        // The closure gives nil where Raven's block falls through to its end.
        let earlyOut = RectDef.scratch { r2 -> Int32? in
            r2.x = Menus[i].window.rect.x - 3
            r2.y = Menus[i].window.rect.y - 3
            r2.h = 7
            r2.w = r2.h
            if Rect_ContainsPoint(r2, Float(x), Float(y)) {
                return CURSOR_SIZER
            }
            return nil
        }
        if let earlyOut {
            return earlyOut
        }
        i += 1
    }
    return CURSOR_ARROW
}

/// Source: oracle/codemp/ui/ui_shared.c:9918
func Display_HandleKey(_ key: Int32, _ down: Bool, _ x: Int32, _ y: Int32) {
    // Port-note: The draft of this statement did not compile, and the compiler wrote "argument passed to call that takes no arguments".
    // Raven wrote: menuDef_t *menu = (menuDef_t *) Display_CaptureItem(x, y);
    portMissing("Display_HandleKey", source: "oracle/codemp/ui/ui_shared.c:9918")
    // Port-note: A read of `menu`, a local the draft left as a hole.
    // Raven wrote: if (menu == NULL) { menu = Menu_GetFocused(); }
    portMissing("Display_HandleKey", source: "oracle/codemp/ui/ui_shared.c:9918")
    // Port-note: A read of `menu`, a local the draft left as a hole.
    // Raven wrote: if (menu) { Menu_HandleKey(menu, key, down ); }
    portMissing("Display_HandleKey", source: "oracle/codemp/ui/ui_shared.c:9918")
}

/// Source: oracle/codemp/ui/ui_shared.c:9928
private func Window_CacheContents(_ window: JKAMP.WindowDef) {
    if window.cinematicName != nil {
        let cin: Int32 = DC!.runPlayCinematic(window.cinematicName!, 0, 0, 0, 0)
        DC!.runStopCinematic(cin)
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:9938
private func Item_CacheContents(_ item: ItemDef) {
    Window_CacheContents(item.window)
}

/// Source: oracle/codemp/ui/ui_shared.c:9945
private func Menu_CacheContents(_ menu: MenuDef) {
    var i: Int32
    Window_CacheContents(menu.window)
    i = 0
    while i < menu.itemCount {
        Item_CacheContents(menu.items[i]!)
        i += 1
    }

    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: if (menu->soundName && *menu->soundName) { DC->registerSound(menu->soundName); }
    portMissing("Menu_CacheContents", source: "oracle/codemp/ui/ui_shared.c:9945")
}

/// Source: oracle/codemp/ui/ui_shared.c:9960
func Display_CacheAll() {
    var i: Int32
    i = 0
    while i < menuCount {
        Menu_CacheContents(Menus[i])
        i += 1
    }
}

/// Source: oracle/codemp/ui/ui_shared.c:9968
private func Menu_OverActiveItem(_ menu: MenuDef, _ x: Float, _ y: Float) -> Bool {
    if (menu.window.flags & (WINDOW_VISIBLE | WINDOW_FORCED)) != 0 {
        //JLFMOUSE
        if Rect_ContainsPoint(menu.window.rect, x, y) {
            var i: Int32
            i = 0
            while i < menu.itemCount {
                // turn off focus each item
                // menu->items[i].window.flags &= ~WINDOW_HASFOCUS;

                if !((menu.items[i]!.window.flags & (WINDOW_VISIBLE | WINDOW_FORCED)) != 0) {
                    i += 1
                    continue
                }

                if (menu.items[i]!.window.flags & WINDOW_DECORATION) != 0 {
                    i += 1
                    continue
                }

                if Rect_ContainsPoint(menu.items[i]!.window.rect, x, y) {
                    let overItem: ItemDef? = menu.items[i]
                    if overItem!.type == ITEM_TYPE_TEXT && overItem!.text != nil {
                        if Rect_ContainsPoint(overItem!.window.rect, x, y) {
                            return true
                        } else {
                            i += 1
                            continue
                        }
                    } else {
                        return true
                    }
                }
                i += 1
            }
        }
    }
    return false
}
