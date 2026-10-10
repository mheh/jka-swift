/// Source: oracle/codemp/game/q_shared.c:280
private nonisolated(unsafe) var com_token = CharBuf(MAX_TOKEN_CHARS)

/// Source: oracle/codemp/game/q_shared.c:281
private nonisolated(unsafe) var com_parsename = CharBuf(MAX_TOKEN_CHARS)

/// Source: oracle/codemp/game/q_shared.c:282
private nonisolated(unsafe) var com_lines: Int32 = 0

/// Source: oracle/codemp/game/q_shared.c:13
public func GetIDForString(_ table: Slots<JKAShared.StringIDTable>, _ string: String) -> Int32 {
    var index: Int32 = 0

    while (table[index].name != nil) && (!table[index].name!.isEmpty) {
        if Q_stricmp(table[index].name!, string) == 0 {
            return table[index].id
        }

        index += 1
    }

    return -1
}

/// Source: oracle/codemp/game/q_shared.c:35
public func GetStringForID(_ table: Slots<JKAShared.StringIDTable>, _ id: Int32) -> String? {
    var index: Int32 = 0

    while (table[index].name != nil) && (!table[index].name!.isEmpty) {
        if table[index].id == id {
            return table[index].name
        }

        index += 1
    }

    return nil
}

/// Source: oracle/codemp/game/q_shared.c:51
public func Com_Clampi(_ min: Int32, _ max: Int32, _ value: Int32) -> Int32 {
    if value < min {
        return min
    }
    if value > max {
        return max
    }
    return value
}

/// Source: oracle/codemp/game/q_shared.c:64
public func Com_Clamp(_ min: Float, _ max: Float, _ value: Float) -> Float {
    if value < min {
        return min
    }
    if value > max {
        return max
    }
    return value
}

/**
```
============
COM_SkipPath
============
```
*/
/// Source: oracle/codemp/game/q_shared.c:80
public func COM_SkipPath(_ pathname: inout JKAShared.CharBuf) -> Int32 {
    var last: Int32
    var pathnameIndex: Int32 = 0

    last = pathnameIndex
    while pathname[pathnameIndex] != 0 {
        if pathname[pathnameIndex] == Int32(ascii: "/") {
            last = pathnameIndex + 1
        }
        pathnameIndex += 1
    }
    return last
}

/**
```
============
COM_StripExtension
============
```
*/
/// Source: oracle/codemp/game/q_shared.c:99
public func COM_StripExtension(_ `in`: String, _ out: inout JKAShared.CharBuf) {
    var outIndex: Int32 = 0
    // Raven steps his own ``in`` parameter through its bytes, so the body walks a TextCursor over a copy of them.
    var `in` = TextCursor(CharBuf(`in`))
    while `in`.byte != 0 && `in`.byte != Int32(ascii: ".") {
        out[outIndex] = `in`.byte
        outIndex += 1
        `in`.advance()
    }
    out[outIndex] = 0
}

/**
```
==================
COM_DefaultExtension
==================
```
*/
/// Source: oracle/codemp/game/q_shared.c:112
public func COM_DefaultExtension(_ path: inout JKAShared.CharBuf, _ maxSize: Int32, _ `extension`: String) {
    var oldPath = CharBuf(64)
    var src: Int32

    //
    // if path doesn't have a .EXT, append extension
    // (extension should include the .)
    //
    src = strlen(path) - 1

    // Raven reads the byte before the buffer for an empty path, and the Swift subscript traps there.
    while path[src] != Int32(ascii: "/") && src != 0 {
        if path[src] == Int32(ascii: ".") {
            return // it has an extension
        }
        src -= 1
    }

    Q_strncpyz(&oldPath, String(path), Int32((oldPath).count))
    Com_sprintf(&path, maxSize, "%s%s", oldPath, `extension`)
}

/// Source: oracle/codemp/game/q_shared.c:162
public func ShortSwap(_ l: Int32) -> Int32 {
    let b1: byte
    let b2: byte

    b1 = UInt8(truncatingIfNeeded: l & 255)
    b2 = UInt8(truncatingIfNeeded: (l >> 8) & 255)

    return (Int32(b1) << 8) + Int32(b2)
}

/// Source: oracle/codemp/game/q_shared.c:172
public func ShortNoSwap(_ l: Int32) -> Int32 {
    return l
}

/// Source: oracle/codemp/game/q_shared.c:177
public func LongSwap(_ l: Int32) -> Int32 {
    let b1: byte
    let b2: byte
    let b3: byte
    let b4: byte

    b1 = UInt8(truncatingIfNeeded: l & 255)
    b2 = UInt8(truncatingIfNeeded: (l >> 8) & 255)
    b3 = UInt8(truncatingIfNeeded: (l >> 16) & 255)
    b4 = UInt8(truncatingIfNeeded: (l >> 24) & 255)

    return (Int32(Int32(b1)) << 24) + (Int32(Int32(b2)) << 16) + (Int32(Int32(b3)) << 8) + Int32(b4)
}

/// Source: oracle/codemp/game/q_shared.c:189
public func LongNoSwap(_ l: Int32) -> Int32 {
    return l
}

/// Source: oracle/codemp/game/q_shared.c:194
public func Long64Swap(_ ll: Int64) -> Int64 {
    return ll.byteSwapped
}

/// Source: oracle/codemp/game/q_shared.c:210
public func Long64NoSwap(_ ll: Int64) -> Int64 {
    return ll
}

/// Source: oracle/codemp/game/q_shared.c:220
public func FloatSwap(_ f: Float) -> Float {
    return Float(bitPattern: f.bitPattern.byteSwapped)
}

/// Source: oracle/codemp/game/q_shared.c:230
public func FloatNoSwap(_ f: Float) -> Float {
    return f
}

/// Source: oracle/codemp/game/q_shared.c:284
public func COM_BeginParseSession(_ name: String) {
    com_lines = 0
    Com_sprintf(&com_parsename, Int32((com_parsename).count), "%s", name)
}

/// Source: oracle/codemp/game/q_shared.c:290
public func COM_GetCurrentParseLine() -> Int32 {
    return com_lines
}

/// Source: oracle/codemp/game/q_shared.c:295
public func COM_Parse(_ data_p: inout JKAShared.TextCursor) -> String {
    return COM_ParseExt(&data_p, true)
}

/// Source: oracle/codemp/game/q_shared.c:300
public func COM_ParseError(_ format: inout JKAShared.CharBuf, _ args: any JKAShared.FormatArg...) {
    var string = CharBuf(4096)

    // Port-note: The guide has no form for `vsprintf` into a buffer from the variadic arguments.
    // Raven wrote: vsprintf (string, format, argptr)
    portMissing("COM_ParseError", source: "oracle/codemp/game/q_shared.c:300")

    Com_Printf("ERROR: %s, line %d: %s\n", com_parsename, com_lines, string)
}

/// Source: oracle/codemp/game/q_shared.c:312
public func COM_ParseWarning(_ format: inout JKAShared.CharBuf, _ args: any JKAShared.FormatArg...) {
    var string = CharBuf(4096)

    // Port-note: The guide has no form for `vsprintf` into a buffer from the variadic arguments.
    // Raven wrote: vsprintf (string, format, argptr)
    portMissing("COM_ParseWarning", source: "oracle/codemp/game/q_shared.c:312")

    Com_Printf("WARNING: %s, line %d: %s\n", com_parsename, com_lines, string)
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
public func SkipWhitespace(_ data: JKAShared.TextCursor, _ hasNewLines: inout Bool) -> JKAShared.TextCursor {
    var c: Int32
    // Raven assigns his own `data` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
    var data = data

    while true {
        c = data.byte
        if !(c <= Int32(ascii: " ")) { break }
        if c == 0 {
            return TextCursor()
        }
        if c == Int32(ascii: "\n") {
            com_lines += 1
            hasNewLines = true
        }
        data.advance()
    }

    return data
}

/// Source: oracle/codemp/game/q_shared.c:353
public func COM_Compress(_ data_p: inout JKAShared.CharBuf) -> Int32 {
    var `in`: Int32
    var out: Int32
    var c: Int32
    var newline: Bool = false
    var whitespace: Bool = false

    out = 0
    `in` = out
    while true {
        c = data_p[`in`]
        if !(c != 0) { break }
        // skip double slash comments
        if c == Int32(ascii: "/") && data_p[`in` + 1] == Int32(ascii: "/") {
            while data_p[`in`] != 0 && data_p[`in`] != Int32(ascii: "\n") {
                `in` += 1
            }
            // skip /* */ comments
        } else if c == Int32(ascii: "/") && data_p[`in` + 1] == Int32(ascii: "*") {
            while data_p[`in`] != 0 && (data_p[`in`] != Int32(ascii: "*") || data_p[`in` + 1] != Int32(ascii: "/")) {
                `in` += 1
            }
            if data_p[`in`] != 0 {
                `in` += 2
            }
            // record when we hit a newline
        } else if c == Int32(ascii: "\n") || c == Int32(ascii: "\r") {
            newline = true
            `in` += 1
            // record when we hit whitespace
        } else if c == Int32(ascii: " ") || c == Int32(ascii: "\t") {
            whitespace = true
            `in` += 1
            // an actual token
        } else {
            // if we have a pending newline, emit it (and it counts as whitespace)
            if newline {
                data_p[out] = Int32(ascii: "\n")
                out += 1
                newline = false
                whitespace = false
            }
            if whitespace {
                data_p[out] = Int32(ascii: " ")
                out += 1
                whitespace = false
            }

            // copy quoted strings unmolested
            if c == Int32(ascii: "\"") {
                data_p[out] = c
                out += 1
                `in` += 1
                while 1 != 0 {
                    c = data_p[`in`]
                    if c != 0 && c != Int32(ascii: "\"") {
                        data_p[out] = c
                        out += 1
                        `in` += 1
                    } else {
                        break
                    }
                }
                if c == Int32(ascii: "\"") {
                    data_p[out] = c
                    out += 1
                    `in` += 1
                }
            } else {
                data_p[out] = c
                out += 1
                `in` += 1
            }
        }
    }
    data_p[out] = 0
    return out
}

/// Source: oracle/codemp/game/q_shared.c:421
public func COM_ParseExt(_ data_p: inout JKAShared.TextCursor, _ allowLineBreaks: Bool) -> String {
    var c: Int32 = 0
    var len: Int32
    var hasNewLines: Bool = false
    var data: TextCursor

    data = data_p
    len = 0
    com_token[0] = 0

    // make sure incoming data is valid
    if data.isNull {
        data_p = TextCursor()
        return String(com_token)
    }

    while 1 != 0 {
        // skip whitespace
        data = SkipWhitespace(data, &hasNewLines)
        if data.isNull {
            data_p = TextCursor()
            return String(com_token)
        }
        if hasNewLines && !allowLineBreaks {
            data_p = data
            return String(com_token)
        }

        c = data.byte

        // skip double slash comments
        if c == Int32(ascii: "/") && data[1] == Int32(ascii: "/") {
            data.advance(by: 2)
            while data.byte != 0 && data.byte != Int32(ascii: "\n") {
                data.advance()
            }
        }
        // skip /* */ comments
        else if c == Int32(ascii: "/") && data[1] == Int32(ascii: "*") {
            data.advance(by: 2)
            while data.byte != 0 && (data.byte != Int32(ascii: "*") || data[1] != Int32(ascii: "/")) {
                data.advance()
            }
            if data.byte != 0 {
                data.advance(by: 2)
            }
        } else {
            break
        }
    }

    // handle quoted strings
    if c == Int32(ascii: "\"") {
        data.advance()
        while 1 != 0 {
            c = data.byte
            data.advance()
            if c == Int32(ascii: "\"") || c == 0 {
                com_token[len] = 0
                data_p = data
                return String(com_token)
            }
            if len < MAX_TOKEN_CHARS {
                com_token[len] = c
                len += 1
            }
        }
    }

    // parse a regular word
    repeat {
        if len < MAX_TOKEN_CHARS {
            com_token[len] = c
            len += 1
        }
        data.advance()
        c = data.byte
        if c == Int32(ascii: "\n") {
            com_lines += 1
        }
    } while c > 32

    if len == MAX_TOKEN_CHARS {
        //		Com_Printf ("Token exceeded %i chars, discarded.\n", MAX_TOKEN_CHARS);
        len = 0
    }
    com_token[len] = 0

    data_p = data
    return String(com_token)
}

/**
```
===============
COM_ParseString
===============
```
*/
/// Source: oracle/codemp/game/q_shared.c:588
public func COM_ParseString(_ data: inout JKAShared.TextCursor, _ s: inout String) -> Bool {
    //	*s = COM_ParseExt( data, qtrue );
    s = COM_ParseExt(&data, false)
    if s.isEmpty {
        Com_Printf("unexpected EOF\n")
        return true
    }
    return false
}

/**
```
===============
COM_ParseInt
===============
```
*/
/// Source: oracle/codemp/game/q_shared.c:605
public func COM_ParseInt(_ data: inout JKAShared.TextCursor, _ i: inout Int32) -> Bool {
    let token: String

    token = COM_ParseExt(&data, false)
    if token.isEmpty {
        Com_Printf("unexpected EOF\n")
        return true
    }

    i = atoi(token)
    return false
}

/**
```
===============
COM_ParseFloat
===============
```
*/
/// Source: oracle/codemp/game/q_shared.c:625
public func COM_ParseFloat(_ data: inout JKAShared.TextCursor, _ f: inout Float) -> Bool {
    let token: String

    token = COM_ParseExt(&data, false)
    if token.isEmpty {
        Com_Printf("unexpected EOF\n")
        return true
    }

    f = atof(token)
    return false
}

/**
```
===============
COM_ParseVec4
===============
```
*/
/// Source: oracle/codemp/game/q_shared.c:645
public func COM_ParseVec4(_ buffer: inout JKAShared.TextCursor, _ c: inout JKAShared.vec4_t) -> Bool {
    var i: Int32
    var f: Float = 0

    i = 0
    while i < 4 {
        if COM_ParseFloat(&buffer, &f) {
            return true
        }
        (c)[Int(i)] = f
        i += 1
    }
    return false
}

/**
```
==================
COM_MatchToken
==================
```
*/
/// Source: oracle/codemp/game/q_shared.c:666
public func COM_MatchToken(_ buf_p: inout JKAShared.TextCursor, _ match: String) {
    let token: String

    token = COM_Parse(&buf_p)
    if strcmp(token, match) != 0 {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'ERR_DROP' in scope".
        // Raven wrote: Com_Error( ERR_DROP, "MatchToken: %s != %s", token, match )
        portMissing("COM_MatchToken", source: "oracle/codemp/game/q_shared.c:666")
    }
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
public func SkipBracedSection(_ program: inout JKAShared.TextCursor) {
    var token: String
    var depth: Int32

    depth = 0
    repeat {
        token = COM_ParseExt(&program, true)
        if CharBuf(token)[1] == 0 {
            if CharBuf(token)[0] == Int32(ascii: "{") {
                depth += 1
            } else if CharBuf(token)[0] == Int32(ascii: "}") {
                depth -= 1
            }
        }
    } while depth != 0 && program != nil
}

/**
```
=================
SkipRestOfLine
=================
```
*/
/// Source: oracle/codemp/game/q_shared.c:708
public func SkipRestOfLine(_ data: inout JKAShared.TextCursor) {
    var p: TextCursor
    var c: Int32

    p = data
    while true {
        c = p.byte
        p.advance()
        if !(c != 0) { break }
        if c == Int32(ascii: "\n") {
            com_lines += 1
            break
        }
    }

    data = p
}

/// Source: oracle/codemp/game/q_shared.c:724
public func Parse1DMatrix(_ buf_p: inout JKAShared.TextCursor, _ x: Int32, _ m: inout [Float]) {
    var token: String
    var i: Int32

    COM_MatchToken(&buf_p, "(")

    i = 0
    while i < x {
        token = COM_Parse(&buf_p)
        m[i] = atof(token)
        i += 1
    }

    COM_MatchToken(&buf_p, ")")
}

/// Source: oracle/codemp/game/q_shared.c:738
public func Parse2DMatrix(_ buf_p: inout JKAShared.TextCursor, _ y: Int32, _ x: Int32, _ m: inout [Float]) {
    var i: Int32

    COM_MatchToken(&buf_p, "(")

    i = 0
    while i < y {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutableRawPointer' to expected argument type '[Float]'".
        // Raven wrote: Parse1DMatrix (buf_p, x, m + i * x)
        portMissing("Parse2DMatrix", source: "oracle/codemp/game/q_shared.c:738")
        i += 1
    }

    COM_MatchToken(&buf_p, ")")
}

/// Source: oracle/codemp/game/q_shared.c:750
public func Parse3DMatrix(_ buf_p: inout JKAShared.TextCursor, _ z: Int32, _ y: Int32, _ x: Int32, _ m: inout [Float]) {
    var i: Int32

    COM_MatchToken(&buf_p, "(")

    i = 0
    while i < z {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutableRawPointer' to expected argument type '[Float]'".
        // Raven wrote: Parse2DMatrix (buf_p, y, x, m + i * x*y)
        portMissing("Parse3DMatrix", source: "oracle/codemp/game/q_shared.c:750")
        i += 1
    }

    COM_MatchToken(&buf_p, ")")
}

/// Source: oracle/codemp/game/q_shared.c:771
public func Q_isprint(_ c: Int32) -> Int32 {
    if c >= 0x20 && c <= 0x7E {
        return (1)
    }
    return (0)
}

/// Source: oracle/codemp/game/q_shared.c:778
public func Q_islower(_ c: Int32) -> Int32 {
    if c >= Int32(ascii: "a") && c <= Int32(ascii: "z") {
        return (1)
    }
    return (0)
}

/// Source: oracle/codemp/game/q_shared.c:785
public func Q_isupper(_ c: Int32) -> Int32 {
    if c >= Int32(ascii: "A") && c <= Int32(ascii: "Z") {
        return (1)
    }
    return (0)
}

/// Source: oracle/codemp/game/q_shared.c:792
public func Q_isalpha(_ c: Int32) -> Int32 {
    if (c >= Int32(ascii: "a") && c <= Int32(ascii: "z")) || (c >= Int32(ascii: "A") && c <= Int32(ascii: "Z")) {
        return (1)
    }
    return (0)
}

/// Source: oracle/codemp/game/q_shared.c:799
public func Q_strrchr(_ string: String, _ c: Int32) -> Int32? {
    let cc: CChar = CChar(truncatingIfNeeded: c)
    var s: Int32
    var sp: Int32? = nil
    // Raven steps a pointer through the bytes of `string`, so the body reads a CharBuf copy of them.
    let string = CharBuf(string)

    s = 0

    while string[s] != 0 {
        if string[s] == cc {
            sp = s
        }
        s += 1
    }
    if cc == 0 {
        sp = s
    }

    return sp
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
public func Q_strncpyz(_ dest: inout JKAShared.CharBuf, _ src: String, _ destsize: Int32) {
    var destIndex: Int32 = 0
    // bk001129 - also NULL dest
    if destsize < 1 {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'ERR_FATAL' in scope".
        // Raven wrote: Com_Error(ERR_FATAL,"Q_strncpyz: destsize < 1" )
        portMissing("Q_strncpyz", source: "oracle/codemp/game/q_shared.c:826")
    }

    // Port-note: The draft of this statement did not compile, and the compiler wrote "extra argument 'at' in call".
    // Raven wrote: strncpy( dest, src, destsize-1 )
    portMissing("Q_strncpyz", source: "oracle/codemp/game/q_shared.c:826")
    dest[destIndex + destsize - 1] = 0
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
// Raven returns the argument, which the caller already holds.
public func Q_strlwr(_ s1: inout JKAShared.CharBuf) {
    // Port-note: A pointer local `char * s` with no view.
    // Raven wrote: char *s;
    portMissing("Q_strlwr", source: "oracle/codemp/game/q_shared.c:905")

    // Port-note: A store into `s`, a local the draft left as a hole.
    // Raven wrote: s = s1
    portMissing("Q_strlwr", source: "oracle/codemp/game/q_shared.c:905")
    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: while ( *s ) { *s = tolower(*s); s++; }
    portMissing("Q_strlwr", source: "oracle/codemp/game/q_shared.c:905")
    return
}

/// The value form of `Q_strlwr`, for a view's `char` array or a pooled string, where no `CharBuf` sits behind the text.
/// A view field writes back through its setter, `tagOwner.name = Q_strlwr(tagOwner.name)`, and a pooled string takes it before the pool.
public func Q_strlwr(_ s1: String) -> String {
    var buf = CharBuf(s1)
    Q_strlwr(&buf)
    return String(buf)
}

/// Source: oracle/codemp/game/q_shared.c:916
// Raven returns the argument, which the caller already holds.
public func Q_strupr(_ s1: inout JKAShared.CharBuf) {
    // Port-note: A pointer local `char * s` with no view.
    // Raven wrote: char *s;
    portMissing("Q_strupr", source: "oracle/codemp/game/q_shared.c:916")

    // Port-note: A store into `s`, a local the draft left as a hole.
    // Raven wrote: s = s1
    portMissing("Q_strupr", source: "oracle/codemp/game/q_shared.c:916")
    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: while ( *s ) { *s = toupper(*s); s++; }
    portMissing("Q_strupr", source: "oracle/codemp/game/q_shared.c:916")
    return
}

/// The value form of `Q_strupr`, for a view's `char` array or a pooled string, where no `CharBuf` sits behind the text.
/// A view field writes back through its setter, `tagOwner.name = Q_strupr(tagOwner.name)`, and a pooled string takes it before the pool.
public func Q_strupr(_ s1: String) -> String {
    var buf = CharBuf(s1)
    Q_strupr(&buf)
    return String(buf)
}

// never goes past bounds or leaves without a terminating 0
/// Source: oracle/codemp/game/q_shared.c:929
public func Q_strcat(_ dest: inout JKAShared.CharBuf, _ size: Int32, _ src: String) {
    let l1: Int32

    l1 = strlen(dest)
    if l1 >= size {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'ERR_FATAL' in scope".
        // Raven wrote: Com_Error( ERR_FATAL, "Q_strcat: already overflowed" )
        portMissing("Q_strcat", source: "oracle/codemp/game/q_shared.c:929")
    }
    // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot convert value of type 'UnsafeMutableRawPointer' to expected argument type 'CharBuf'".
    // Raven wrote: Q_strncpyz( dest + l1, src, size - l1 )
    portMissing("Q_strcat", source: "oracle/codemp/game/q_shared.c:929")
}

/// Raven's `Q_strcat(marker, size, src)` through a pointer into the buffer, which is the same rule over the bytes from `offset` on.
/// The suffix is a copy, so the call writes it back into `dest` at that byte.
public func Q_strcat(_ dest: inout CharBuf, _ size: Int32, _ src: String, at offset: some BinaryInteger) {
    let start = Int32(offset)
    var suffix = dest[start...]
    Q_strcat(&suffix, size, src)
    for i in 0 ..< Int32(suffix.count) {
        dest[start + i] = suffix[i] as Int8
    }
}

/// Source: oracle/codemp/game/q_shared.c:940
public func Q_PrintStrlen(_ string: String) -> Int32 {
    var len: Int32
    // Port-note: A pointer local `const char * p` with no view.
    // Raven wrote: const char *p;
    portMissing("Q_PrintStrlen", source: "oracle/codemp/game/q_shared.c:940")


    len = 0
    // Port-note: A store into `p`, a local the draft left as a hole.
    // Raven wrote: p = string
    portMissing("Q_PrintStrlen", source: "oracle/codemp/game/q_shared.c:940")
    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: while( *p ) { if( Q_IsColorString( p ) ) { p += 2; continue; } p++; len++; }
    portMissing("Q_PrintStrlen", source: "oracle/codemp/game/q_shared.c:940")

    return len
}

/// Source: oracle/codemp/game/q_shared.c:963
// Raven returns the argument, which the caller already holds.
public func Q_CleanStr(_ string: inout JKAShared.CharBuf) {
    // Port-note: A pointer local `char * d` with no view.
    // Raven wrote: char* d;
    portMissing("Q_CleanStr", source: "oracle/codemp/game/q_shared.c:963")
    // Port-note: A pointer local `char * s` with no view.
    // Raven wrote: char* s;
    portMissing("Q_CleanStr", source: "oracle/codemp/game/q_shared.c:963")
    var c: Int32

    // Port-note: A store into `s`, a local the draft left as a hole.
    // Raven wrote: s = string
    portMissing("Q_CleanStr", source: "oracle/codemp/game/q_shared.c:963")
    // Port-note: A store into `d`, a local the draft left as a hole.
    // Raven wrote: d = string
    portMissing("Q_CleanStr", source: "oracle/codemp/game/q_shared.c:963")
    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: while ((c = *s) != 0 ) { if ( Q_IsColorString( s ) ) { s++; } else if ( c >= 0x20 && c <= 0x7E ) { *d++ = c; } s++; }
    portMissing("Q_CleanStr", source: "oracle/codemp/game/q_shared.c:963")
    // Port-note: A pointer dereference the draft cannot place.
    // Raven wrote: *d = '\0'
    portMissing("Q_CleanStr", source: "oracle/codemp/game/q_shared.c:963")

    return
}

/// The value form of `Q_CleanStr`, for a view's `char` array or a pooled string, where no `CharBuf` sits behind the text.
/// A view field writes back through its setter, `tagOwner.name = Q_CleanStr(tagOwner.name)`, and a pooled string takes it before the pool.
public func Q_CleanStr(_ string: String) -> String {
    var buf = CharBuf(string)
    Q_CleanStr(&buf)
    return String(buf)
}

/// Source: oracle/codemp/game/q_shared.c:985
public func Com_sprintf(_ dest: inout JKAShared.CharBuf, _ size: Int32, _ fmt: String, _ args: any JKAShared.FormatArg...) {
    let len: Int32
    var bigbuffer = CharBuf(32000)

    // Port-note: The guide has no form for `vsprintf` into a buffer from the variadic arguments.
    // Raven wrote: len = vsprintf (bigbuffer,fmt,argptr)
    portMissing("Com_sprintf", source: "oracle/codemp/game/q_shared.c:985")
    if len >= Int32((bigbuffer).count) {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'ERR_FATAL' in scope".
        // Raven wrote: Com_Error( ERR_FATAL, "Com_sprintf: overflowed bigbuffer" )
        portMissing("Com_sprintf", source: "oracle/codemp/game/q_shared.c:985")
    }
    if len >= size {
        Com_Printf("Com_sprintf: overflow of %i in %i\n", len, size)
    }
    Q_strncpyz(&dest, String(bigbuffer), size)
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
public func va(_ format: String, _ args: any JKAShared.FormatArg...) -> String {
    // Raven's two static buffers exist because C cannot return a string, and no caller keeps a result across a second call.
    JKAShared.format(format, args)
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
public func Info_ValueForKey(_ s: String, _ key: String) -> String {
    var pkey = CharBuf(8192)
    // Port-note: A local `char[2][8192] value` the table has no type for.
    // Raven wrote: static char value[2][BIG_INFO_VALUE];
    portMissing("Info_ValueForKey", source: "oracle/codemp/game/q_shared.c:1051")
    // work without stomping on each other
    // Port-note: A static local `valueindex` a statement reads before it writes, storage that outlives the call.
    // Raven wrote: static int valueindex = 0;
    portMissing("Info_ValueForKey", source: "oracle/codemp/game/q_shared.c:1051")
    // Port-note: A pointer local `char * o` with no view.
    // Raven wrote: char *o;
    portMissing("Info_ValueForKey", source: "oracle/codemp/game/q_shared.c:1051")
    // Raven steps his own `s` parameter through its bytes, so the body walks a TextCursor over a copy of them.
    var s = TextCursor(CharBuf(s))


    if strlen(s.text) >= BIG_INFO_STRING {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'ERR_DROP' in scope".
        // Raven wrote: Com_Error( ERR_DROP, "Info_ValueForKey: oversize infostring" )
        portMissing("Info_ValueForKey", source: "oracle/codemp/game/q_shared.c:1051")
    }

    // Port-note: A store into `valueindex`, a local the draft left as a hole.
    // Raven wrote: valueindex ^= 1
    portMissing("Info_ValueForKey", source: "oracle/codemp/game/q_shared.c:1051")
    if s.byte == Int32(ascii: "\\") {
        s.advance()
    }
    while 1 != 0 {
        // Port-note: A store into `o`, a local the draft left as a hole.
        // Raven wrote: o = pkey
        portMissing("Info_ValueForKey", source: "oracle/codemp/game/q_shared.c:1051")
        while s.byte != Int32(ascii: "\\") {
            if s.byte == 0 {
                return ""
            }
            // Port-note: A pointer dereference the draft cannot place.
            // Raven wrote: *o++ = *s++
            portMissing("Info_ValueForKey", source: "oracle/codemp/game/q_shared.c:1051")
        }
        // Port-note: A pointer dereference the draft cannot place.
        // Raven wrote: *o = 0
        portMissing("Info_ValueForKey", source: "oracle/codemp/game/q_shared.c:1051")
        s.advance()

        // Port-note: A store into `o`, a local the draft left as a hole.
        // Raven wrote: o = value[valueindex]
        portMissing("Info_ValueForKey", source: "oracle/codemp/game/q_shared.c:1051")

        while s.byte != Int32(ascii: "\\") && s.byte != 0 {
            // Port-note: A pointer dereference the draft cannot place.
            // Raven wrote: *o++ = *s++
            portMissing("Info_ValueForKey", source: "oracle/codemp/game/q_shared.c:1051")
        }
        // Port-note: A pointer dereference the draft cannot place.
        // Raven wrote: *o = 0
        portMissing("Info_ValueForKey", source: "oracle/codemp/game/q_shared.c:1051")

        if Q_stricmp(key, String(pkey)) == 0 {
            // Port-note: A read of `value`, a local the draft left as a hole.
            // Raven wrote: return value[valueindex]
            portMissing("Info_ValueForKey", source: "oracle/codemp/game/q_shared.c:1051")
        }

        if s.byte == 0 {
            break
        }
        s.advance()
    }

    return ""
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
public func Info_NextPair(_ head: inout JKAShared.TextCursor, _ key: inout JKAShared.CharBuf, _ value: inout JKAShared.CharBuf) {
    var o: Int32
    var s: TextCursor
    var keyIndex: Int32 = 0
    var valueIndex: Int32 = 0

    s = head

    if s.byte == Int32(ascii: "\\") {
        s.advance()
    }
    key[keyIndex + 0] = 0
    value[valueIndex + 0] = 0

    o = keyIndex
    while s.byte != Int32(ascii: "\\") {
        if s.byte == 0 {
            key[o] = 0
            head = s
            return
        }
        key[o] = s.byte
        o += 1
        s.advance()
    }
    key[o] = 0
    s.advance()

    o = valueIndex
    while s.byte != Int32(ascii: "\\") && s.byte != 0 {
        value[o] = s.byte
        o += 1
        s.advance()
    }
    value[o] = 0

    head = s
}

/**
```
===================
Info_RemoveKey
===================
```
*/
/// Source: oracle/codemp/game/q_shared.c:1147
public func Info_RemoveKey(_ s: inout JKAShared.CharBuf, _ key: String) {
    var start: Int32
    var pkey = CharBuf(1024)
    var value = CharBuf(1024)
    var o: Int32
    var sIndex: Int32 = 0

    if strlen(s) >= MAX_INFO_STRING {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'ERR_DROP' in scope".
        // Raven wrote: Com_Error( ERR_DROP, "Info_RemoveKey: oversize infostring" )
        portMissing("Info_RemoveKey", source: "oracle/codemp/game/q_shared.c:1147")
    }

    if strchr(key, Int32(ascii: "\\")) != nil {
        return
    }

    while 1 != 0 {
        start = sIndex
        if s[sIndex] == Int32(ascii: "\\") {
            sIndex += 1
        }
        o = 0
        while s[sIndex] != Int32(ascii: "\\") {
            if s[sIndex] == 0 {
                return
            }
            pkey[o] = s[sIndex]
            o += 1
            sIndex += 1
        }
        pkey[o] = 0
        sIndex += 1

        o = 0
        while s[sIndex] != Int32(ascii: "\\") && s[sIndex] != 0 {
            if s[sIndex] == 0 {
                return
            }
            value[o] = s[sIndex]
            o += 1
            sIndex += 1
        }
        value[o] = 0

        if strcmp(key, pkey) == 0 {
            strcpy(&s, String(s[sIndex...]), at: start) // remove this part
            return
        }

        if s[sIndex] == 0 {
            return
        }
    }
}

/**
```
===================
Info_RemoveKey_Big
===================
```
*/
/// Source: oracle/codemp/game/q_shared.c:1202
public func Info_RemoveKey_Big(_ s: inout JKAShared.CharBuf, _ key: String) {
    var start: Int32
    var pkey = CharBuf(8192)
    var value = CharBuf(8192)
    var o: Int32
    var sIndex: Int32 = 0

    if strlen(s) >= BIG_INFO_STRING {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'ERR_DROP' in scope".
        // Raven wrote: Com_Error( ERR_DROP, "Info_RemoveKey_Big: oversize infostring" )
        portMissing("Info_RemoveKey_Big", source: "oracle/codemp/game/q_shared.c:1202")
    }

    if strchr(key, Int32(ascii: "\\")) != nil {
        return
    }

    while 1 != 0 {
        start = sIndex
        if s[sIndex] == Int32(ascii: "\\") {
            sIndex += 1
        }
        o = 0
        while s[sIndex] != Int32(ascii: "\\") {
            if s[sIndex] == 0 {
                return
            }
            pkey[o] = s[sIndex]
            o += 1
            sIndex += 1
        }
        pkey[o] = 0
        sIndex += 1

        o = 0
        while s[sIndex] != Int32(ascii: "\\") && s[sIndex] != 0 {
            if s[sIndex] == 0 {
                return
            }
            value[o] = s[sIndex]
            o += 1
            sIndex += 1
        }
        value[o] = 0

        if strcmp(key, pkey) == 0 {
            strcpy(&s, String(s[sIndex...]), at: start) // remove this part
            return
        }

        if s[sIndex] == 0 {
            return
        }
    }
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
    if strchr(s, Int32(ascii: "\"")) != nil {
        return false
    }
    if strchr(s, Int32(ascii: ";")) != nil {
        return false
    }
    return true
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
public func Info_SetValueForKey(_ s: inout JKAShared.CharBuf, _ key: String, _ value: String) {
    var newi = CharBuf(1024)

    if strlen(s) >= MAX_INFO_STRING {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'ERR_DROP' in scope".
        // Raven wrote: Com_Error( ERR_DROP, "Info_SetValueForKey: oversize infostring" )
        portMissing("Info_SetValueForKey", source: "oracle/codemp/game/q_shared.c:1280")
    }

    if strchr(key, Int32(ascii: "\\")) != nil || strchr(value, Int32(ascii: "\\")) != nil {
        Com_Printf("Can't use keys or values with a \\\n")
        return
    }

    if strchr(key, Int32(ascii: ";")) != nil || strchr(value, Int32(ascii: ";")) != nil {
        Com_Printf("Can't use keys or values with a semicolon\n")
        return
    }

    if strchr(key, Int32(ascii: "\"")) != nil || strchr(value, Int32(ascii: "\"")) != nil {
        Com_Printf("Can't use keys or values with a \"\n")
        return
    }

    Info_RemoveKey(&s, key)
    if strlen(value) == 0 {
        return
    }

    Com_sprintf(&newi, Int32((newi).count), "\\%s\\%s", key, value)

    if strlen(newi) + strlen(s) > MAX_INFO_STRING {
        Com_Printf("Info string length exceeded\n")
        return
    }

    strcat(&newi, s)
    strcpy(&s, newi)
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
public func Info_SetValueForKey_Big(_ s: inout JKAShared.CharBuf, _ key: String, _ value: String) {
    var newi = CharBuf(8192)

    if strlen(s) >= BIG_INFO_STRING {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "cannot find 'ERR_DROP' in scope".
        // Raven wrote: Com_Error( ERR_DROP, "Info_SetValueForKey: oversize infostring" )
        portMissing("Info_SetValueForKey_Big", source: "oracle/codemp/game/q_shared.c:1328")
    }

    if strchr(key, Int32(ascii: "\\")) != nil || strchr(value, Int32(ascii: "\\")) != nil {
        Com_Printf("Can't use keys or values with a \\\n")
        return
    }

    if strchr(key, Int32(ascii: ";")) != nil || strchr(value, Int32(ascii: ";")) != nil {
        Com_Printf("Can't use keys or values with a semicolon\n")
        return
    }

    if strchr(key, Int32(ascii: "\"")) != nil || strchr(value, Int32(ascii: "\"")) != nil {
        Com_Printf("Can't use keys or values with a \"\n")
        return
    }

    Info_RemoveKey_Big(&s, key)
    if strlen(value) == 0 {
        return
    }

    Com_sprintf(&newi, Int32((newi).count), "\\%s\\%s", key, value)

    if strlen(newi) + strlen(s) > BIG_INFO_STRING {
        Com_Printf("BIG Info string length exceeded\n")
        return
    }

    strcat(&s, newi)
}
