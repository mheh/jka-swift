/// Source: oracle/codemp/game/q_shared.c:13
// TODO: Port signature
// Raven wrote: int GetIDForString ( stringID_table_t *table, const char *string )
// No table row for `stringID_table_t * table`.
public func GetIDForString() -> Never {
    // TODO: Port GetIDForString
    portMissing("GetIDForString", source: "oracle/codemp/game/q_shared.c:13")
}

/// Source: oracle/codemp/game/q_shared.c:35
// TODO: Port signature
// Raven wrote: const char *GetStringForID( stringID_table_t *table, int id )
// No table row for `stringID_table_t * table`.
public func GetStringForID() -> Never {
    // TODO: Port GetStringForID
    portMissing("GetStringForID", source: "oracle/codemp/game/q_shared.c:35")
}

/// Source: oracle/codemp/game/q_shared.c:51
public func Com_Clampi(_ min: Int32, _ max: Int32, _ value: Int32) -> Int32 {
    // TODO: Port Com_Clampi
    portMissing("Com_Clampi", source: "oracle/codemp/game/q_shared.c:51")
}

/// Source: oracle/codemp/game/q_shared.c:64
public func Com_Clamp(_ min: Float, _ max: Float, _ value: Float) -> Float {
    // TODO: Port Com_Clamp
    portMissing("Com_Clamp", source: "oracle/codemp/game/q_shared.c:64")
}

/**
```
============
COM_SkipPath
============
```
*/
/// Source: oracle/codemp/game/q_shared.c:80
// TODO: Port signature
// Raven wrote: char *COM_SkipPath (char *pathname)
// No table row for the return `char *`.
public func COM_SkipPath() -> Never {
    // TODO: Port COM_SkipPath
    portMissing("COM_SkipPath", source: "oracle/codemp/game/q_shared.c:80")
}

/**
```
============
COM_StripExtension
============
```
*/
/// Source: oracle/codemp/game/q_shared.c:99
public func COM_StripExtension(_ `in`: String, _ out: inout CharBuf) {
    // TODO: Port COM_StripExtension
    portMissing("COM_StripExtension", source: "oracle/codemp/game/q_shared.c:99")
}

/**
```
==================
COM_DefaultExtension
==================
```
*/
/// Source: oracle/codemp/game/q_shared.c:112
public func COM_DefaultExtension(_ path: inout CharBuf, _ maxSize: Int32, _ `extension`: String) {
    // TODO: Port COM_DefaultExtension
    portMissing("COM_DefaultExtension", source: "oracle/codemp/game/q_shared.c:112")
}

/// Source: oracle/codemp/game/q_shared.c:162
public func ShortSwap(_ l: Int16) -> Int16 {
    // TODO: Port ShortSwap
    portMissing("ShortSwap", source: "oracle/codemp/game/q_shared.c:162")
}

/// Source: oracle/codemp/game/q_shared.c:172
public func ShortNoSwap(_ l: Int16) -> Int16 {
    // TODO: Port ShortNoSwap
    portMissing("ShortNoSwap", source: "oracle/codemp/game/q_shared.c:172")
}

/// Source: oracle/codemp/game/q_shared.c:177
public func LongSwap(_ l: Int32) -> Int32 {
    // TODO: Port LongSwap
    portMissing("LongSwap", source: "oracle/codemp/game/q_shared.c:177")
}

/// Source: oracle/codemp/game/q_shared.c:189
public func LongNoSwap(_ l: Int32) -> Int32 {
    // TODO: Port LongNoSwap
    portMissing("LongNoSwap", source: "oracle/codemp/game/q_shared.c:189")
}

/// Source: oracle/codemp/game/q_shared.c:194
// TODO: Port signature
// Raven wrote: qint64 Long64Swap (qint64 ll)
// No table row for `qint64 ll`.
public func Long64Swap() -> Never {
    // TODO: Port Long64Swap
    portMissing("Long64Swap", source: "oracle/codemp/game/q_shared.c:194")
}

/// Source: oracle/codemp/game/q_shared.c:210
// TODO: Port signature
// Raven wrote: qint64 Long64NoSwap (qint64 ll)
// No table row for `qint64 ll`.
public func Long64NoSwap() -> Never {
    // TODO: Port Long64NoSwap
    portMissing("Long64NoSwap", source: "oracle/codemp/game/q_shared.c:210")
}

/// Source: oracle/codemp/game/q_shared.c:220
// TODO: Port signature
// Raven wrote: float FloatSwap (const float *f)
// No table row for `const float * f`.
public func FloatSwap() -> Never {
    // TODO: Port FloatSwap
    portMissing("FloatSwap", source: "oracle/codemp/game/q_shared.c:220")
}

/// Source: oracle/codemp/game/q_shared.c:230
// TODO: Port signature
// Raven wrote: float FloatNoSwap (const float *f)
// No table row for `const float * f`.
public func FloatNoSwap() -> Never {
    // TODO: Port FloatNoSwap
    portMissing("FloatNoSwap", source: "oracle/codemp/game/q_shared.c:230")
}

/// Source: oracle/codemp/game/q_shared.c:284
public func COM_BeginParseSession(_ name: String) {
    // TODO: Port COM_BeginParseSession
    portMissing("COM_BeginParseSession", source: "oracle/codemp/game/q_shared.c:284")
}

/// Source: oracle/codemp/game/q_shared.c:290
public func COM_GetCurrentParseLine() -> Int32 {
    // TODO: Port COM_GetCurrentParseLine
    portMissing("COM_GetCurrentParseLine", source: "oracle/codemp/game/q_shared.c:290")
}

/// Source: oracle/codemp/game/q_shared.c:295
// TODO: Port signature
// Raven wrote: char *COM_Parse( const char **data_p )
// No table row for `const char ** data_p`.
public func COM_Parse() -> Never {
    // TODO: Port COM_Parse
    portMissing("COM_Parse", source: "oracle/codemp/game/q_shared.c:295")
}

/// Source: oracle/codemp/game/q_shared.c:300
public func COM_ParseError(_ format: inout CharBuf) {
    // TODO: Port COM_ParseError
    portMissing("COM_ParseError", source: "oracle/codemp/game/q_shared.c:300")
}

/// Source: oracle/codemp/game/q_shared.c:312
public func COM_ParseWarning(_ format: inout CharBuf) {
    // TODO: Port COM_ParseWarning
    portMissing("COM_ParseWarning", source: "oracle/codemp/game/q_shared.c:312")
}

/**
```
==============
COM_Parse

Parse a token out of a string
Will never return NULL, just empty strings

If "allowLineBreaks" is qtrue then an empty
string will be returned if the next token is
a newline.
==============
```
*/
/// Source: oracle/codemp/game/q_shared.c:336
// TODO: Port signature
// Raven wrote: const char *SkipWhitespace( const char *data, qboolean *hasNewLines )
// No table row for the return `const char *`.
public func SkipWhitespace() -> Never {
    // TODO: Port SkipWhitespace
    portMissing("SkipWhitespace", source: "oracle/codemp/game/q_shared.c:336")
}

/// Source: oracle/codemp/game/q_shared.c:353
public func COM_Compress(_ data_p: inout CharBuf) -> Int32 {
    // TODO: Port COM_Compress
    portMissing("COM_Compress", source: "oracle/codemp/game/q_shared.c:353")
}

/// Source: oracle/codemp/game/q_shared.c:421
// TODO: Port signature
// Raven wrote: char *COM_ParseExt( const char **data_p, qboolean allowLineBreaks )
// No table row for `const char ** data_p`.
public func COM_ParseExt() -> Never {
    // TODO: Port COM_ParseExt
    portMissing("COM_ParseExt", source: "oracle/codemp/game/q_shared.c:421")
}

/**
```
===============
COM_ParseString
===============
```
*/
/// Source: oracle/codemp/game/q_shared.c:588
// TODO: Port signature
// Raven wrote: qboolean COM_ParseString( const char **data, const char **s )
// No table row for `const char ** data`.
public func COM_ParseString() -> Never {
    // TODO: Port COM_ParseString
    portMissing("COM_ParseString", source: "oracle/codemp/game/q_shared.c:588")
}

/**
```
===============
COM_ParseInt
===============
```
*/
/// Source: oracle/codemp/game/q_shared.c:605
// TODO: Port signature
// Raven wrote: qboolean COM_ParseInt( const char **data, int *i )
// No table row for `const char ** data`.
public func COM_ParseInt() -> Never {
    // TODO: Port COM_ParseInt
    portMissing("COM_ParseInt", source: "oracle/codemp/game/q_shared.c:605")
}

/**
```
===============
COM_ParseFloat
===============
```
*/
/// Source: oracle/codemp/game/q_shared.c:625
// TODO: Port signature
// Raven wrote: qboolean COM_ParseFloat( const char **data, float *f )
// No table row for `const char ** data`.
public func COM_ParseFloat() -> Never {
    // TODO: Port COM_ParseFloat
    portMissing("COM_ParseFloat", source: "oracle/codemp/game/q_shared.c:625")
}

/**
```
===============
COM_ParseVec4
===============
```
*/
/// Source: oracle/codemp/game/q_shared.c:645
// TODO: Port signature
// Raven wrote: qboolean COM_ParseVec4( const char **buffer, vec4_t *c)
// No table row for `const char ** buffer`.
public func COM_ParseVec4() -> Never {
    // TODO: Port COM_ParseVec4
    portMissing("COM_ParseVec4", source: "oracle/codemp/game/q_shared.c:645")
}

/**
```
==================
COM_MatchToken
==================
```
*/
/// Source: oracle/codemp/game/q_shared.c:666
// TODO: Port signature
// Raven wrote: void COM_MatchToken( const char **buf_p, char *match )
// No table row for `const char ** buf_p`.
public func COM_MatchToken() -> Never {
    // TODO: Port COM_MatchToken
    portMissing("COM_MatchToken", source: "oracle/codemp/game/q_shared.c:666")
}

/**
```
=================
SkipBracedSection

The next token should be an open brace.
Skips until a matching close brace is found.
Internal brace depths are properly skipped.
=================
```
*/
/// Source: oracle/codemp/game/q_shared.c:685
// TODO: Port signature
// Raven wrote: void SkipBracedSection (const char **program)
// No table row for `const char ** program`.
public func SkipBracedSection() -> Never {
    // TODO: Port SkipBracedSection
    portMissing("SkipBracedSection", source: "oracle/codemp/game/q_shared.c:685")
}

/**
```
=================
SkipRestOfLine
=================
```
*/
/// Source: oracle/codemp/game/q_shared.c:708
// TODO: Port signature
// Raven wrote: void SkipRestOfLine ( const char **data )
// No table row for `const char ** data`.
public func SkipRestOfLine() -> Never {
    // TODO: Port SkipRestOfLine
    portMissing("SkipRestOfLine", source: "oracle/codemp/game/q_shared.c:708")
}

/// Source: oracle/codemp/game/q_shared.c:724
// TODO: Port signature
// Raven wrote: void Parse1DMatrix (const char **buf_p, int x, float *m)
// No table row for `const char ** buf_p`.
public func Parse1DMatrix() -> Never {
    // TODO: Port Parse1DMatrix
    portMissing("Parse1DMatrix", source: "oracle/codemp/game/q_shared.c:724")
}

/// Source: oracle/codemp/game/q_shared.c:738
// TODO: Port signature
// Raven wrote: void Parse2DMatrix (const char **buf_p, int y, int x, float *m)
// No table row for `const char ** buf_p`.
public func Parse2DMatrix() -> Never {
    // TODO: Port Parse2DMatrix
    portMissing("Parse2DMatrix", source: "oracle/codemp/game/q_shared.c:738")
}

/// Source: oracle/codemp/game/q_shared.c:750
// TODO: Port signature
// Raven wrote: void Parse3DMatrix (const char **buf_p, int z, int y, int x, float *m)
// No table row for `const char ** buf_p`.
public func Parse3DMatrix() -> Never {
    // TODO: Port Parse3DMatrix
    portMissing("Parse3DMatrix", source: "oracle/codemp/game/q_shared.c:750")
}

/// Source: oracle/codemp/game/q_shared.c:771
public func Q_isprint(_ c: Int32) -> Int32 {
    // TODO: Port Q_isprint
    portMissing("Q_isprint", source: "oracle/codemp/game/q_shared.c:771")
}

/// Source: oracle/codemp/game/q_shared.c:778
public func Q_islower(_ c: Int32) -> Int32 {
    // TODO: Port Q_islower
    portMissing("Q_islower", source: "oracle/codemp/game/q_shared.c:778")
}

/// Source: oracle/codemp/game/q_shared.c:785
public func Q_isupper(_ c: Int32) -> Int32 {
    // TODO: Port Q_isupper
    portMissing("Q_isupper", source: "oracle/codemp/game/q_shared.c:785")
}

/// Source: oracle/codemp/game/q_shared.c:792
public func Q_isalpha(_ c: Int32) -> Int32 {
    // TODO: Port Q_isalpha
    portMissing("Q_isalpha", source: "oracle/codemp/game/q_shared.c:792")
}

/// Source: oracle/codemp/game/q_shared.c:799
// TODO: Port signature
// Raven wrote: char* Q_strrchr( const char* string, int c )
// No table row for the return `char *`.
public func Q_strrchr() -> Never {
    // TODO: Port Q_strrchr
    portMissing("Q_strrchr", source: "oracle/codemp/game/q_shared.c:799")
}

/**
```
=============
Q_strncpyz

Safe strncpy that ensures a trailing zero
=============
```
*/
/// Source: oracle/codemp/game/q_shared.c:826
public func Q_strncpyz(_ dest: inout String, _ src: String, _ destsize: Int32) {
    // TODO: Port Q_strncpyz
    portMissing("Q_strncpyz", source: "oracle/codemp/game/q_shared.c:826")
}

/// Source: oracle/codemp/game/q_shared.c:842
public func Q_stricmpn(_ s1: CharBuf, _ s2: CharBuf, _ n: Int32) -> Int32 {
    var c1: Int32
    var c2: Int32
    var n = n

    // bk001129 - moved in 1.17 fix not in id codebase
    // Port-note: Raven returns 0, -1, or 1 here for a NULL s1 or a NULL s2. A `String` is non-optional, so the guard has no Swift form.

    // Port-note: A C `char` is signed on the target build, so a byte above 127 reads as a negative int. The port keeps that sign.
    var i1 = 0
    var i2 = 0

    repeat {
        c1 = s1[i1]
        i1 += 1
        c2 = s2[i2]
        i2 += 1

        // Raven wrote `if (!n--)`, which reads n, then decrements it, and tests the value it read.
        let nBefore = n
        n -= 1
        if nBefore == 0 {
            return 0		// strings are equal until end point
        }

        if c1 != c2 {
            // Swift has no C character literal, so Raven's `'a'` is spelled `Int32(ascii: "a")`.
            if c1 >= Int32(ascii: "a") && c1 <= Int32(ascii: "z") {
                c1 -= (Int32(ascii: "a") - Int32(ascii: "A"))
            }
            if c2 >= Int32(ascii: "a") && c2 <= Int32(ascii: "z") {
                c2 -= (Int32(ascii: "a") - Int32(ascii: "A"))
            }
            if c1 != c2 {
                return c1 < c2 ? -1 : 1
            }
        }
    } while c1 != 0

    return 0		// strings are equal
}

/// A `String` caller converts once at the call.
public func Q_stricmpn(_ s1: String, _ s2: String, _ n: Int32) -> Int32 {
    Q_stricmpn(CharBuf(s1), CharBuf(s2), n)
}

/// Source: oracle/codemp/game/q_shared.c:881
public func Q_strncmp(_ s1: CharBuf, _ s2: CharBuf, _ n: Int32) -> Int32 {
    var c1: Int32
    var c2: Int32
    var n = n

    // Port-note: A C `char` is signed on the target build, so a byte above 127 reads as a negative int. The port keeps that sign.
    var i1 = 0
    var i2 = 0

    repeat {
        c1 = s1[i1]
        i1 += 1
        c2 = s2[i2]
        i2 += 1

        // Raven wrote `if (!n--)`, which reads n, then decrements it, and tests the value it read.
        let nBefore = n
        n -= 1
        if nBefore == 0 {
            return 0		// strings are equal until end point
        }

        if c1 != c2 {
            return c1 < c2 ? -1 : 1
        }
    } while c1 != 0

    return 0		// strings are equal
}

/// A `String` caller converts once at the call.
public func Q_strncmp(_ s1: String, _ s2: String, _ n: Int32) -> Int32 {
    Q_strncmp(CharBuf(s1), CharBuf(s2), n)
}

/// Source: oracle/codemp/game/q_shared.c:900
public func Q_stricmp(_ s1: CharBuf, _ s2: CharBuf) -> Int32 {
    // Port-note: Raven returns -1 when s1 or s2 is NULL. A `String` is non-optional, so the guard has no Swift form.
    return Q_stricmpn(s1, s2, 99999)
}

/// A `String` caller converts once at the call.
public func Q_stricmp(_ s1: String, _ s2: String) -> Int32 {
    Q_stricmp(CharBuf(s1), CharBuf(s2))
}

/// Source: oracle/codemp/game/q_shared.c:905
// TODO: Port signature
// Raven wrote: char *Q_strlwr( char *s1 )
// No table row for the return `char *`.
public func Q_strlwr() -> Never {
    // TODO: Port Q_strlwr
    portMissing("Q_strlwr", source: "oracle/codemp/game/q_shared.c:905")
}

/// Source: oracle/codemp/game/q_shared.c:916
// TODO: Port signature
// Raven wrote: char *Q_strupr( char *s1 )
// No table row for the return `char *`.
public func Q_strupr() -> Never {
    // TODO: Port Q_strupr
    portMissing("Q_strupr", source: "oracle/codemp/game/q_shared.c:916")
}

// never goes past bounds or leaves without a terminating 0
/// Source: oracle/codemp/game/q_shared.c:929
public func Q_strcat(_ dest: inout String, _ size: Int32, _ src: String) {
    // TODO: Port Q_strcat
    portMissing("Q_strcat", source: "oracle/codemp/game/q_shared.c:929")
}

/// Source: oracle/codemp/game/q_shared.c:940
public func Q_PrintStrlen(_ string: String) -> Int32 {
    // TODO: Port Q_PrintStrlen
    portMissing("Q_PrintStrlen", source: "oracle/codemp/game/q_shared.c:940")
}

/// Source: oracle/codemp/game/q_shared.c:963
// TODO: Port signature
// Raven wrote: char *Q_CleanStr( char *string )
// No table row for the return `char *`.
public func Q_CleanStr() -> Never {
    // TODO: Port Q_CleanStr
    portMissing("Q_CleanStr", source: "oracle/codemp/game/q_shared.c:963")
}

/// Source: oracle/codemp/game/q_shared.c:985
public func Com_sprintf(_ dest: inout CharBuf, _ size: Int32, _ fmt: String) {
    // TODO: Port Com_sprintf
    portMissing("Com_sprintf", source: "oracle/codemp/game/q_shared.c:985")
}

/**
```
============
va

does a varargs printf into a temp buffer, so I don't need to have
varargs versions of all text functions.
FIXME: make this buffer size safe someday
============
```
*/
/// Source: oracle/codemp/game/q_shared.c:1017
// TODO: Port signature
// Raven wrote: char * QDECL va( const char *format, ... )
// No table row for the return `char *`.
public func va() -> Never {
    // TODO: Port va
    portMissing("va", source: "oracle/codemp/game/q_shared.c:1017")
}

/**
```
===============
Info_ValueForKey

Searches the string for the given
key and returns the associated value, or an empty string.
FIXME: overflow check?
===============
```
*/
/// Source: oracle/codemp/game/q_shared.c:1051
// TODO: Port signature
// Raven wrote: char *Info_ValueForKey( const char *s, const char *key )
// No table row for the return `char *`.
public func Info_ValueForKey() -> Never {
    // TODO: Port Info_ValueForKey
    portMissing("Info_ValueForKey", source: "oracle/codemp/game/q_shared.c:1051")
}

/**
```
===================
Info_NextPair

Used to itterate through all the key/value pairs in an info string
===================
```
*/
/// Source: oracle/codemp/game/q_shared.c:1108
// TODO: Port signature
// Raven wrote: void Info_NextPair( const char **head, char *key, char *value )
// No table row for `const char ** head`.
public func Info_NextPair() -> Never {
    // TODO: Port Info_NextPair
    portMissing("Info_NextPair", source: "oracle/codemp/game/q_shared.c:1108")
}

/**
```
===================
Info_RemoveKey
===================
```
*/
/// Source: oracle/codemp/game/q_shared.c:1147
public func Info_RemoveKey(_ s: inout CharBuf, _ key: String) {
    // TODO: Port Info_RemoveKey
    portMissing("Info_RemoveKey", source: "oracle/codemp/game/q_shared.c:1147")
}

/**
```
===================
Info_RemoveKey_Big
===================
```
*/
/// Source: oracle/codemp/game/q_shared.c:1202
public func Info_RemoveKey_Big(_ s: inout CharBuf, _ key: String) {
    // TODO: Port Info_RemoveKey_Big
    portMissing("Info_RemoveKey_Big", source: "oracle/codemp/game/q_shared.c:1202")
}

/**
```
==================
Info_Validate

Some characters are illegal in info strings because they
can mess up the server's parsing
==================
```
*/
/// Source: oracle/codemp/game/q_shared.c:1263
public func Info_Validate(_ s: String) -> Bool {
    // TODO: Port Info_Validate
    portMissing("Info_Validate", source: "oracle/codemp/game/q_shared.c:1263")
}

/**
```
==================
Info_SetValueForKey

Changes or adds a key/value pair
==================
```
*/
/// Source: oracle/codemp/game/q_shared.c:1280
public func Info_SetValueForKey(_ s: inout CharBuf, _ key: String, _ value: String) {
    // TODO: Port Info_SetValueForKey
    portMissing("Info_SetValueForKey", source: "oracle/codemp/game/q_shared.c:1280")
}

/**
```
==================
Info_SetValueForKey_Big

Changes or adds a key/value pair
==================
```
*/
/// Source: oracle/codemp/game/q_shared.c:1328
public func Info_SetValueForKey_Big(_ s: inout CharBuf, _ key: String, _ value: String) {
    // TODO: Port Info_SetValueForKey_Big
    portMissing("Info_SetValueForKey_Big", source: "oracle/codemp/game/q_shared.c:1328")
}
