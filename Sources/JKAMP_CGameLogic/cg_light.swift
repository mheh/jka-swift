import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/// Source: oracle/codemp/cgame/cg_light.c:7
var cl_lightstyle: Slots<Clightstyle> { world.storage.cl_lightstyle }

/// Source: oracle/codemp/cgame/cg_light.c:8
var lastofs: Int32 {
    get { world.variables.lastofs }
    set { world.variables.lastofs = newValue }
}

/**
```
================
FX_ClearLightStyles
================
```
*/
/// Source: oracle/codemp/cgame/cg_light.c:15
public func CG_ClearLightStyles() {
    var i: Int32

    cl_lightstyle.zero()
    lastofs = -1

    i = 0
    while i < MAX_LIGHT_STYLES * 3 {
        CG_SetLightstyle(i)
        i += 1
    }
}

/**
```
================
FX_RunLightStyles
================
```
*/
/// Source: oracle/codemp/cgame/cg_light.c:33
public func CG_RunLightStyles() {
    let ofs: Int32
    var i: Int32
    var lsIndex: Int32 = 0

    ofs = cg.time / 50
    //	if (ofs == lastofs)
    //		return;
    lastofs = ofs

    i = 0
    lsIndex = 0
    while i < MAX_LIGHT_STYLES {
        if cl_lightstyle[lsIndex].length == 0 {
            cl_lightstyle[lsIndex].value[3] = 255
            cl_lightstyle[lsIndex].value[2] = cl_lightstyle[lsIndex].value[3]
            cl_lightstyle[lsIndex].value[1] = cl_lightstyle[lsIndex].value[2]
            cl_lightstyle[lsIndex].value[0] = cl_lightstyle[lsIndex].value[1]
        } else if cl_lightstyle[lsIndex].length == 1 {
            cl_lightstyle[lsIndex].value[0] = cl_lightstyle[lsIndex].map[0][0]
            cl_lightstyle[lsIndex].value[1] = cl_lightstyle[lsIndex].map[0][1]
            cl_lightstyle[lsIndex].value[2] = cl_lightstyle[lsIndex].map[0][2]
            cl_lightstyle[lsIndex].value[3] = 255 //ls->map[0][3];
        } else {
            cl_lightstyle[lsIndex].value[0] = cl_lightstyle[lsIndex].map[ofs % cl_lightstyle[lsIndex].length][0]
            cl_lightstyle[lsIndex].value[1] = cl_lightstyle[lsIndex].map[ofs % cl_lightstyle[lsIndex].length][1]
            cl_lightstyle[lsIndex].value[2] = cl_lightstyle[lsIndex].map[ofs % cl_lightstyle[lsIndex].length][2]
            cl_lightstyle[lsIndex].value[3] = 255 //ls->map[ofs%ls->length][3];
        }
        // AI: Raven read the four value bytes as one int through a pointer cast. The bytes join here in the little-endian order of every target.
        let value = cl_lightstyle[lsIndex].value
        trap_R_SetLightStyle(i, Int32(value[0]) | (Int32(value[1]) << 8) | (Int32(value[2]) << 16) | (Int32(value[3]) << 24))
        i += 1
        lsIndex += 1
    }
}

/// Source: oracle/codemp/cgame/cg_light.c:68
public func CG_SetLightstyle(_ i: Int32) {
    let s: CharBuf
    let j: Int32
    var k: Int32

    s = CharBuf(CG_ConfigString(i + CS_LIGHT_STYLES))
    j = strlen(s)
    if j >= MAX_QPATH {
        Com_Error(ERR_DROP, "svc_lightstyle length=%i", j)
    }

    cl_lightstyle[(i / 3)].length = j
    k = 0
    while k < j {
        // Raven's one expression is two terms here, because the compiler cannot type-check it whole in reasonable time.
        let fraction: Float = Float(s[k] - Int32(ascii: "a")) / Float(Int32(ascii: "z") - Int32(ascii: "a"))
        cl_lightstyle[(i / 3)].map[k][(i % 3)] = UInt8(Double(fraction) * 255.0)
        k += 1
    }
}
