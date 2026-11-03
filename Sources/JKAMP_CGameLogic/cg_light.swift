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
func CG_ClearLightStyles() {
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
func CG_RunLightStyles() {
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
        // Port-note: A pointer dereference the draft cannot place.
        // Raven wrote: trap_R_SetLightStyle(i, *(int*)ls->value)
        portMissing("CG_RunLightStyles", source: "oracle/codemp/cgame/cg_light.c:33")
        i += 1
        lsIndex += 1
    }
}

/// Source: oracle/codemp/cgame/cg_light.c:68
func CG_SetLightstyle(_ i: Int32) {
    let s: String
    let j: Int32
    var k: Int32

    s = CG_ConfigString(i + CS_LIGHT_STYLES)
    j = strlen(s)
    if j >= MAX_QPATH {
        Com_Error(ERR_DROP, "svc_lightstyle length=%i", j)
    }

    cl_lightstyle[(i / 3)].length = j
    k = 0
    while k < j {
        // Port-note: The draft of this statement did not compile, and the compiler wrote "the compiler is unable to type-check this expression in reasonable time; try breaking up the expression into distinct sub-expressions".
        // Raven wrote: cl_lightstyle[(i/3)].map[k][(i%3)] = (float)(s[k]-'a')/(float)('z'-'a') * 255.0
        portMissing("CG_SetLightstyle", source: "oracle/codemp/cgame/cg_light.c:68")
        k += 1
    }
}
