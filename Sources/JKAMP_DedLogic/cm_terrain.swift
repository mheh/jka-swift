import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:21
let BRUSH_SIDES_PER_TERXEL = 8 as Int32

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1312
// AI: Raven takes the address of the parameter `height` of FlattenArea. The body copies it into one zeroed slot on the storage class.
var height_FlattenArea: Slots<Int32> { world.storage.height_FlattenArea }

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1312
// AI: Raven declares `height2` on the stack of FlattenArea and takes its address. The body copies it into one zeroed slot on the storage class.
var height2_FlattenArea: Slots<Int32> { world.storage.height2_FlattenArea }

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1340
// AI: Raven declares `info` on the stack of FlattenArea. The function uses one zeroed allocation on the storage class.
var info_FlattenArea: Slots<Int32> { world.storage.info_FlattenArea }

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1067
func CM_CircularIterate(_ data: Slots<UInt8>, _ width: Int32, _ height: Int32, _ xo: Int32, _ yo: Int32, _ insideRadius: Int32, _ outsideRadius: Int32, _ user: Slots<Int32>, _ callback: ((Slots<UInt8>, Float, Slots<Int32>) -> Void)?) {
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
                        callback!(work, (radius - Float(insideRadius)) / Float(outsideRadius - insideRadius), user)
                    }
                }
                x += 1
            }
        }
        y += 1
    }
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1094
func CM_ForceHeight(_ work: Slots<UInt8>, _ lerp: Float, _ user: Slots<Int32>) {
    work[0] = UInt8(Com_Clamp(0, 255, Float(Int32(user[0]))))
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1100
func CM_GetAverage(_ work: Slots<UInt8>, _ lerp: Float, _ user: Slots<Int32>) {
    // C widens the unsigned byte to `int` at the add.
    user[0] += Int32(work[0])
    user[1] += 1
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1106
func CM_Smooth(_ work: Slots<UInt8>, _ lerp: Float, _ user: Slots<Int32>) {
    // Foundation's M_PI is the double literal of Raven's macro, and the qualifier breaks the tie with the float constant of JKAShared.
    let smooth: Float = Float(sin(Foundation.M_PI / 2 * 3 + Double(1.0 - lerp) * (Foundation.M_PI / 2)) + 1.0)
    //	float smooth = (1.0f - lerp);

    // C widens the unsigned byte to `int`, and the store into the byte truncates.
    work[byte: 0] = Int32(work[0]) + Int32(Float(user[0] - Int32(work[0])) * smooth)
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1114
func CM_MakeAverage(_ work: Slots<UInt8>, _ lerp: Float, _ user: Slots<Int32>) {
    var height: Int32
    var diff: Int32

    height = Int32(work[0])
    diff = user[0] - height
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
func CM_InitTerrain(_ configstring: String, _ terrainId: JKAShared.thandle_t, _ server: Bool) -> CCMLandScape? {
    var ls: CCMLandScape?

    ls = CCMLandScape(configstring, server)
    ls!.SetTerrainId(terrainId)

    return (ls)
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1628
// TODO: Port signature
// Raven wrote: void CM_TerrainPatchIterate(const class CCMLandScape *landscape, void (*IterateFunc)( CCMPatch *, void * ), void *userdata)
// No table row for `void (*)( CCMPatch *, void * )` and `void *userdata`.
func CM_TerrainPatchIterate() -> Never {
    // Its callers are tr_terrain.cpp:923 of the renderer and RM_CreateRandomModels, which only the client calls, so the function is dead in the dedicated build.
    // TODO: Port CM_TerrainPatchIterate
    portMissing("CM_TerrainPatchIterate", source: "oracle/codemp/qcommon/cm_terrain.cpp:1628")
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1633
func CM_GetWorldHeight(_ landscape: CCMLandScape?, _ origin: inout JKAShared.vec3_t, _ bounds: [JKAShared.vec3_t], _ aboveGround: Bool) -> Float {
    return landscape!.GetWorldHeight(&origin, bounds, aboveGround)
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1638
func CM_FlattenArea(_ landscape: CCMLandScape?, _ area: CArea?, _ height: Int32, _ save: Bool, _ forceHeight: Bool, _ smooth: Bool) {
    landscape!.FlattenArea(area, height, save, forceHeight, smooth)
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1643
// AI: Raven reads `numCtls` vectors through `vec3_t *ctls`. The parameter is the caller's array, the PARAMS kind `vec3_array` of the method.
func CM_CarveBezierCurve(_ landscape: CCMLandScape?, _ numCtls: Int32, _ ctls: [JKAShared.vec3_t], _ steps: Int32, _ depth: Int32, _ size: Int32) {
    landscape!.CarveBezierCurve(numCtls, ctls, steps, depth, size)
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1648
func CM_SaveArea(_ landscape: CCMLandScape?, _ area: CArea?) {
    landscape!.SaveArea(area)
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1653
func CM_FractionBelowLevel(_ landscape: CCMLandScape?, _ area: CArea?, _ height: Int32) -> Float {
    return (landscape!.FractionBelowLevel(area, height))
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1658
// AI: Raven reads `areaTypeCount` types through `int *areaTypes`. The parameter is the caller's array, the PARAMS kind `int_array` of the method.
func CM_AreaCollision(_ landscape: CCMLandScape?, _ area: CArea?, _ areaTypes: [Int32]?, _ areaTypeCount: Int32) -> Bool {
    return (landscape!.AreaCollision(area, areaTypes, areaTypeCount))
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1663
func CM_GetFirstArea(_ landscape: CCMLandScape?) -> CArea? {
    return (landscape!.GetFirstArea())
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1668
func CM_GetFirstObjectiveArea(_ landscape: CCMLandScape?) -> CArea? {
    return (landscape!.GetFirstObjectiveArea())
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1673
func CM_GetPlayerArea(_ landscape: CCMLandScape?) -> CArea? {
    return (landscape!.GetPlayerArea())
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1678
func CM_GetNextArea(_ landscape: CCMLandScape?) -> CArea? {
    return (landscape!.GetNextArea())
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1683
func CM_GetNextObjectiveArea(_ landscape: CCMLandScape?) -> CArea? {
    return (landscape!.GetNextObjectiveArea())
}

/// Source: oracle/codemp/qcommon/cm_terrain.cpp:1688
func CreateRandomTerrain(_ config: String, _ landscape: CCMLandScape?, _ heightmap: Slots<JKAShared.byte>?, _ width: Int32, _ height: Int32) -> CRandomTerrain? {
    var RandomTerrain: CRandomTerrain? = nil

    var ptr: Int32 = 0
    // AI: Raven declares `unsigned long`, 32 bits in the MSVC build. The local is UInt32, the return of strtoul.
    var seed: UInt32

    seed = strtoul(Info_ValueForKey(config, "seed"), &ptr, 10)

    // C converts the `unsigned long` to the `int` parameter by its bits.
    landscape!.rand_seed(Int32(bitPattern: seed))

    RandomTerrain = CRandomTerrain()
    RandomTerrain!.Init(landscape, heightmap, width, height)

    /*
    	RandomTerrain->CreatePath(0, -1, 0, 9, 0.1, 0.5, 0.5, 0.5, 0.05, 0.08, 0.31, 0.1, 3);
    	RandomTerrain->CreatePath(1, 0, 0, 6, 0.5, 0.5, 0.9, 0.1, 0.08, 0.1, 0.31, 0.1, 0.9);
    	RandomTerrain->CreatePath(2, 0, 0, 6, 0.5, 0.5, 0.9, 0.9, 0.08, 0.1, 0.31, 0.1, 0.9);

    	RandomTerrain->Generate();
    */

    return RandomTerrain
}
