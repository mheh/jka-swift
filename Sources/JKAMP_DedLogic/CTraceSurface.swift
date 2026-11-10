import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's state of one Ghoul2 trace through the surfaces of one model, the ray, the model, and the collision records to fill.
/// `G2_TraceModels` builds one per model, and `G2_TraceSurfaces` walks the surface tree with it.
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:190
final class CTraceSurface {
    var surfaceNum: Int32 = 0
    // AI: Raven holds a reference to the caller's `surfaceInfo_v`. The field holds the array, because the trace only reads it.
    var rootSList: [surfaceInfo_t] = []
    var currentModel: Model? = nil
    var lod: Int32 = 0
    var rayStart = JKAShared.vec3_t()
    var rayEnd = JKAShared.vec3_t()
    var collRecMap: CollisionRecord? = nil
    var entNum: Int32 = 0
    var modelIndex: Int32 = 0
    var skin: Skin? = nil
    var cust_shader: Shader? = nil
    var TransformedVertsArray: Slots<Int32>? = nil
    var traceFlags: Int32 = 0
    var hitOne: Bool = false
    var m_fRadius: Float = 0

    //gore application thing
    var ssize: Float = 0
    var tsize: Float = 0
    var theta: Float = 0
    var goreShader: Int32 = 0
    var ghoul2info: CGhoul2Info? = nil

    //	Procedural-gore application things
    var gore: SkinGoreData? = nil

    /// Source: oracle/codemp/ghoul2/G2_misc.cpp:221
    init(
        _ initsurfaceNum: Int32,
        _ initrootSList: [surfaceInfo_t],
        _ initcurrentModel: Model?,
        _ initlod: Int32,
        _ initrayStart: JKAShared.vec3_t,
        _ initrayEnd: JKAShared.vec3_t,
        _ initcollRecMap: CollisionRecord?,
        _ initentNum: Int32,
        _ initmodelIndex: Int32,
        _ initskin: Skin?,
        _ initcust_shader: Shader?,
        _ initTransformedVertsArray: Slots<Int32>?,
        _ inittraceFlags: Int32,
        _ fRadius: Float,
        _ initssize: Float,
        _ inittsize: Float,
        _ inittheta: Float,
        _ initgoreShader: Int32,
        _ initghoul2info: CGhoul2Info?,
        _ initgore: SkinGoreData?
    ) {
        // TODO: Port CTraceSurface::CTraceSurface
        portMissing("CTraceSurface::CTraceSurface", source: "oracle/codemp/ghoul2/G2_misc.cpp:221")
    }
}
