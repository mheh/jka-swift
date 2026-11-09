import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:21
let BRUSH_SIDES_PER_TERXEL = 8 as Int32

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1067
func CM_CircularIterate(_ data: Slots<UInt8>, _ width: Int32, _ height: Int32, _ xo: Int32, _ yo: Int32, _ insideRadius: Int32, _ outsideRadius: Int32, _ user: inout Int32, _ callback: ((Slots<UInt8>, Float, inout Int32) -> Void)?) {
    var x: Int32
    var y: Int32
    var offset: Int32
    var work: Slots<UInt8>

    y = -outsideRadius
    while y < outsideRadius + 1 {
        if y + yo >= 0 && y + yo < height {
            offset = Int32(sqrtf(Float((outsideRadius * outsideRadius) - (y * y))))
            x = -offset
            while x < offset + 1 {
                if x + xo >= 0 && x + xo < width {
                    let radius: Float = sqrt(Float(x * x + y * y))

                    if radius >= insideRadius {
                        work = data.suffix(from: (x + xo) + ((y + yo) * width))
                        callback!(work, (radius - Float(insideRadius)) / Float(outsideRadius - insideRadius), &user)
                    }
                }
                x += 1
            }
        }
        y += 1
    }
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1094
func CM_ForceHeight(_ work: Slots<UInt8>, _ lerp: Float, _ user: inout Int32) {
    work[0] = UInt8(Com_Clamp(0, 255, Float(Int32(user))))
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1100
func CM_GetAverage(_ work: Slots<UInt8>, _ lerp: Float, _ user: Slots<Int32>) {
    // C widens the unsigned byte to `int` at the add.
    user[0] += Int32(work[0])
    user[1] += 1
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1106
func CM_Smooth(_ work: Slots<UInt8>, _ lerp: Float, _ user: inout Int32) {
    // Foundation's M_PI is the double literal of Raven's macro, and the qualifier breaks the tie with the float constant of JKAShared.
    let smooth: Float = Float(sin(Foundation.M_PI / 2 * 3 + Double(1.0 - lerp) * (Foundation.M_PI / 2)) + 1.0)
    //	float smooth = (1.0f - lerp);

    // C widens the unsigned byte to `int`, and the store into the byte truncates.
    work[byte: 0] = Int32(work[0]) + Int32(Float(user - Int32(work[0])) * smooth)
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1114
func CM_MakeAverage(_ work: Slots<UInt8>, _ lerp: Float, _ user: inout Int32) {
    var height: Int32
    var diff: Int32

    height = Int32(work[0])
    diff = user - height
    if abs(diff) > 3 {
        diff >>= 2
    }
    height += diff
    work[0] = UInt8(Com_Clamp(0, 255, Float(height)))
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1370
func CM_BelowLevel(_ data: Slots<UInt8>, _ lerp: Float, _ info: Slots<Int32>) {
    info[1] += 1
    // C widens the unsigned byte to `int` at the compare.
    if Int32(data[0]) < info[2] {
        info[0] += 1
    }
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1618
// TODO: Port signature
// Raven wrote: class CCMLandScape *CM_InitTerrain(const char *configstring, thandle_t terrainId, bool server)
// No table row for the return `class CCMLandScape *`.
func CM_InitTerrain() -> Never {
    // TODO: Port CM_InitTerrain
    portMissing("CM_InitTerrain", source: "oracle/codemp/qcommon/cm_terrain.cpp:1618")
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1628
// TODO: Port signature
// Raven wrote: void CM_TerrainPatchIterate(const class CCMLandScape *landscape, void (*IterateFunc)( CCMPatch *, void * ), void *userdata)
// No table row for `const class CCMLandScape * landscape`.
func CM_TerrainPatchIterate() -> Never {
    // TODO: Port CM_TerrainPatchIterate
    portMissing("CM_TerrainPatchIterate", source: "oracle/codemp/qcommon/cm_terrain.cpp:1628")
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1633
// TODO: Port signature
// Raven wrote: float CM_GetWorldHeight(const CCMLandScape *landscape, vec3_t origin, const vec3pair_t bounds, bool aboveGround)
// No table row for `const CCMLandScape * landscape`.
func CM_GetWorldHeight() -> Never {
    // TODO: Port CM_GetWorldHeight
    portMissing("CM_GetWorldHeight", source: "oracle/codemp/qcommon/cm_terrain.cpp:1633")
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1638
// TODO: Port signature
// Raven wrote: void CM_FlattenArea(CCMLandScape *landscape, CArea *area, int height, bool save, bool forceHeight, bool smooth )
// No table row for `CCMLandScape * landscape`.
func CM_FlattenArea() -> Never {
    // TODO: Port CM_FlattenArea
    portMissing("CM_FlattenArea", source: "oracle/codemp/qcommon/cm_terrain.cpp:1638")
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1643
// TODO: Port signature
// Raven wrote: void CM_CarveBezierCurve(CCMLandScape *landscape, int numCtls, vec3_t* ctls, int steps, int depth, int size )
// No table row for `CCMLandScape * landscape`.
func CM_CarveBezierCurve() -> Never {
    // TODO: Port CM_CarveBezierCurve
    portMissing("CM_CarveBezierCurve", source: "oracle/codemp/qcommon/cm_terrain.cpp:1643")
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1648
// TODO: Port signature
// Raven wrote: void CM_SaveArea(CCMLandScape *landscape, CArea *area)
// No table row for `CCMLandScape * landscape`.
func CM_SaveArea() -> Never {
    // TODO: Port CM_SaveArea
    portMissing("CM_SaveArea", source: "oracle/codemp/qcommon/cm_terrain.cpp:1648")
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1653
// TODO: Port signature
// Raven wrote: float CM_FractionBelowLevel(CCMLandScape *landscape, CArea *area, int height)
// No table row for `CCMLandScape * landscape`.
func CM_FractionBelowLevel() -> Never {
    // TODO: Port CM_FractionBelowLevel
    portMissing("CM_FractionBelowLevel", source: "oracle/codemp/qcommon/cm_terrain.cpp:1653")
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1658
// TODO: Port signature
// Raven wrote: bool CM_AreaCollision(class CCMLandScape *landscape, class CArea *area, int *areaTypes, int areaTypeCount)
// No table row for `class CCMLandScape * landscape`.
func CM_AreaCollision() -> Never {
    // TODO: Port CM_AreaCollision
    portMissing("CM_AreaCollision", source: "oracle/codemp/qcommon/cm_terrain.cpp:1658")
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1663
// TODO: Port signature
// Raven wrote: CArea *CM_GetFirstArea(CCMLandScape *landscape)
// No table row for `CCMLandScape * landscape`.
func CM_GetFirstArea() -> Never {
    // TODO: Port CM_GetFirstArea
    portMissing("CM_GetFirstArea", source: "oracle/codemp/qcommon/cm_terrain.cpp:1663")
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1668
// TODO: Port signature
// Raven wrote: CArea *CM_GetFirstObjectiveArea(CCMLandScape *landscape)
// No table row for `CCMLandScape * landscape`.
func CM_GetFirstObjectiveArea() -> Never {
    // TODO: Port CM_GetFirstObjectiveArea
    portMissing("CM_GetFirstObjectiveArea", source: "oracle/codemp/qcommon/cm_terrain.cpp:1668")
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1673
// TODO: Port signature
// Raven wrote: CArea *CM_GetPlayerArea(CCMLandScape *landscape)
// No table row for `CCMLandScape * landscape`.
func CM_GetPlayerArea() -> Never {
    // TODO: Port CM_GetPlayerArea
    portMissing("CM_GetPlayerArea", source: "oracle/codemp/qcommon/cm_terrain.cpp:1673")
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1678
// TODO: Port signature
// Raven wrote: CArea *CM_GetNextArea(CCMLandScape *landscape)
// No table row for `CCMLandScape * landscape`.
func CM_GetNextArea() -> Never {
    // TODO: Port CM_GetNextArea
    portMissing("CM_GetNextArea", source: "oracle/codemp/qcommon/cm_terrain.cpp:1678")
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1683
// TODO: Port signature
// Raven wrote: CArea *CM_GetNextObjectiveArea(CCMLandScape *landscape)
// No table row for `CCMLandScape * landscape`.
func CM_GetNextObjectiveArea() -> Never {
    // TODO: Port CM_GetNextObjectiveArea
    portMissing("CM_GetNextObjectiveArea", source: "oracle/codemp/qcommon/cm_terrain.cpp:1683")
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1688
// TODO: Port signature
// Raven wrote: CRandomTerrain *CreateRandomTerrain(const char *config, CCMLandScape *landscape, byte *heightmap, int width, int height)
// No table row for `CCMLandScape * landscape`.
func CreateRandomTerrain() -> Never {
    // TODO: Port CreateRandomTerrain
    portMissing("CreateRandomTerrain", source: "oracle/codemp/qcommon/cm_terrain.cpp:1688")
}
