import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's state of one Ghoul2 trace through the surfaces of one model, the ray, the model, and the collision records to fill.
/// `G2_TraceModels` builds one per model, and `G2_TraceSurfaces` walks the surface tree with it.
/// Source: oracle/codemp/ghoul2/G2_misc.cpp:190
public final class CTraceSurface {
    public var surfaceNum: Int32 = 0
    // AI: Raven holds a reference to the caller's `surfaceInfo_v`. The field holds the array, because the trace only reads it.
    public var rootSList: [surfaceInfo_t] = []
    public var currentModel: Model? = nil
    public var lod: Int32 = 0
    public var rayStart = JKAShared.vec3_t()
    public var rayEnd = JKAShared.vec3_t()
    public var collRecMap: Slots<CollisionRecord>? = nil
    public var entNum: Int32 = 0
    public var modelIndex: Int32 = 0
    public var skin: Skin? = nil
    public var cust_shader: Shader? = nil
    public var TransformedVertsArray: Slots<Int32>? = nil
    public var traceFlags: Int32 = 0
    public var hitOne: Bool = false
    public var m_fRadius: Float = 0

    //gore application thing
    public var ssize: Float = 0
    public var tsize: Float = 0
    public var theta: Float = 0
    public var goreShader: Int32 = 0
    public var ghoul2info: CGhoul2Info? = nil

    //	Procedural-gore application things
    public var gore: SkinGoreData? = nil

    /// Source: oracle/codemp/ghoul2/G2_misc.cpp:221
    public init(
        _ initsurfaceNum: Int32,
        _ initrootSList: [surfaceInfo_t],
        _ initcurrentModel: Model?,
        _ initlod: Int32,
        _ initrayStart: JKAShared.vec3_t,
        _ initrayEnd: JKAShared.vec3_t,
        _ initcollRecMap: Slots<CollisionRecord>?,
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
        self.surfaceNum = initsurfaceNum
        self.rootSList = initrootSList
        self.currentModel = initcurrentModel
        self.lod = initlod
        self.collRecMap = initcollRecMap
        self.entNum = initentNum
        self.modelIndex = initmodelIndex
        self.skin = initskin
        self.cust_shader = initcust_shader
        self.traceFlags = inittraceFlags
        self.TransformedVertsArray = initTransformedVertsArray
        self.m_fRadius = fRadius
        self.ssize = initssize
        self.tsize = inittsize
        self.theta = inittheta
        self.goreShader = initgoreShader
        self.ghoul2info = initghoul2info
        self.gore = initgore
        self.rayStart = initrayStart
        self.rayEnd = initrayEnd
        self.hitOne = false
    }
}
