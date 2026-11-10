import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's collision terrain of a map, the height map, its patches and their brushes, the water, and the flattened areas.
/// `CM_RegisterTerrain` makes the one instance, `cmg.landScape`, and the trace of a terrain brush and the random mission read it.
/// Source: oracle/codemp/qcommon/cm_landscape.h:135
final class CCMLandScape {
    private var mRefCount: Int32 = 0									// Number of times this class is referenced
    private var mTerrainHandle: JKAShared.thandle_t = 0
    // AI: Raven holds the Z_Malloc blocks of cm_terrain.cpp:157, :158, and :215 as `byte *`. Each field is the Slots over the bytes of its block.
    private var mHeightMap: Slots<JKAShared.byte>? = nil								// Pointer to byte array of height samples
    private var mFlattenMap: Slots<JKAShared.byte>? = nil								// Pointer to byte array of flatten samples
    private var mWidth: Int32 = 0
    private var mHeight: Int32 = 0							// Width and height of heightMap excluding the 1 pixel edge
    private var mTerxels: Int32 = 0									// Number of terxels per patch side
    private var mTerxelSize = JKAShared.vec3_t()								// Vector to scale heightMap samples to real world coords
    private var mBounds: [JKAShared.vec3_t] = [JKAShared.vec3_t(), JKAShared.vec3_t()]									// Real world bounds of terrain brush
    private var mSize = JKAShared.vec3_t()										// Size of terrain brush in real world coords excluding 1 patch edge
    private var mPatchSize = JKAShared.vec3_t()									// Size of each patch in the x and y directions only
    private var mPatchScalarSize: Float = 0							// Horizontal size of the patch
    private var mBlockWidth: Int32 = 0
    private var mBlockHeight: Int32 = 0					// Width and height of heightfield on blocks
    // AI: Raven allocates the patches as one Z_Malloc block at cm_terrain.cpp:211. The field is an Array of the patches, rule 17.
    private var mPatches: [CCMPatch] = []
    private var mPatchBrushData: Slots<JKAShared.byte>? = nil							// Base memory from which the patch brush data is taken
    private var mHasPhysics: Bool = false								// Set to true unless disabled
    // TODO: Port mRandomTerrain
    // Raven wrote: CRandomTerrain			*mRandomTerrain;

    private var mBaseWaterHeight: Int32 = 0							// Base water height in terxels
    private var mWaterHeight: Float = 0								// Real world height of the water
    private var mWaterContents: Int32 = 0								// Contents of the water shader
    private var mWaterSurfaceFlags: Int32 = 0							// Surface flags of the water shader

    // AI: Raven declares `unsigned long`, 32 bits in the MSVC build. The field is UInt32, the form of `holdrand` of EngineWorld.
    private var holdrand: UInt32 = 0

    // AI: Raven declares a `list<CArea *>`. The field is an Array of the optional class, rule 17.
    private var mAreas: [CArea?] = []										// List of flattened areas on this landscape
    // AI: Raven holds an iterator into `mAreas`. The field is the index of the element, the form of the cursor `fatalErrorPointer` in rulings.py TYPES.
    private var mAreasIt: Int32 = 0

    // AI: Raven holds HEIGHT_RESOLUTION records by value. The field is an Array of the class, rule 17.
    private var mHeightDetails: [CCMHeightDetails] = (0..<Int(HEIGHT_RESOLUTION)).map { _ in CCMHeightDetails() }			// Surfaceflags per height
    // AI: Raven allocates the coordinates with Z_Malloc at cm_terrain.cpp:979. The field is the Slots over the vectors, the form of `facets` in rulings.py TYPES.
    private var mCoords: Slots<JKAShared.vec3_t>? = nil									// Temp storage for real world coords

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:116
    init(_ configstring: String, _ server: Bool) {
        // TODO: Port CCMLandScape::CCMLandScape
        portMissing("CCMLandScape::CCMLandScape", source: "oracle/codemp/qcommon/cm_terrain.cpp:116")
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1583
    deinit {
        // TODO: Port CCMLandScape::~CCMLandScape
        portMissing("CCMLandScape::~CCMLandScape", source: "oracle/codemp/qcommon/cm_terrain.cpp:1583")
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:593
    func GetPatch(_ x: Int32, _ y: Int32) -> CCMPatch? {
        // TODO: Port CCMLandScape::GetPatch
        portMissing("CCMLandScape::GetPatch", source: "oracle/codemp/qcommon/cm_terrain.cpp:593")
    }

    // Prototypes
    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:600
    func PatchCollide(_ tw: TraceWork, _ trace: JKAMP.Trace, _ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ checkcount: Int32) {
        // TODO: Port CCMLandScape::PatchCollide
        portMissing("CCMLandScape::PatchCollide", source: "oracle/codemp/qcommon/cm_terrain.cpp:600")
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:997
    // TODO: Port signature
    // Raven wrote: void CCMLandScape::TerrainPatchIterate(void (*IterateFunc)( CCMPatch *, void * ), void *userdata) const
    // No table row for `void (*)( CCMPatch *, void * )` and `void *userdata`.
    func TerrainPatchIterate() -> Never {
        // TODO: Port CCMLandScape::TerrainPatchIterate
        portMissing("CCMLandScape::TerrainPatchIterate", source: "oracle/codemp/qcommon/cm_terrain.cpp:997")
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1011
    func GetWorldHeight(_ origin: JKAShared.vec3_t, _ bounds: [JKAShared.vec3_t], _ aboveGround: Bool) -> Float {
        // TODO: Port CCMLandScape::GetWorldHeight
        portMissing("CCMLandScape::GetWorldHeight", source: "oracle/codemp/qcommon/cm_terrain.cpp:1011")
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:836
    func WaterCollide(_ begin: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ fraction: Float) -> Float {
        // TODO: Port CCMLandScape::WaterCollide
        portMissing("CCMLandScape::WaterCollide", source: "oracle/codemp/qcommon/cm_terrain.cpp:836")
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:898
    func UpdatePatches() {
        // TODO: Port CCMLandScape::UpdatePatches
        portMissing("CCMLandScape::UpdatePatches", source: "oracle/codemp/qcommon/cm_terrain.cpp:898")
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:862
    // AI: Raven fills the caller's `vec3_t coords[8]`. The parameter is the Slots over the vectors, the PARAMS kind `table` of a `vec3_t *`.
    func GetTerxelLocalCoords(_ x: Int32, _ y: Int32, _ coords: Slots<JKAShared.vec3_t>) {
        // TODO: Port CCMLandScape::GetTerxelLocalCoords
        portMissing("CCMLandScape::GetTerxelLocalCoords", source: "oracle/codemp/qcommon/cm_terrain.cpp:862")
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:39
    func LoadTerrainDef(_ td: String) {
        // TODO: Port CCMLandScape::LoadTerrainDef
        portMissing("CCMLandScape::LoadTerrainDef", source: "oracle/codemp/qcommon/cm_terrain.cpp:39")
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:26
    func SetShaders(_ height: Int32, _ shader: CmShader?) {
        // TODO: Port CCMLandScape::SetShaders
        portMissing("CCMLandScape::SetShaders", source: "oracle/codemp/qcommon/cm_terrain.cpp:26")
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1312
    func FlattenArea(_ area: CArea?, _ height: Int32, _ save: Bool, _ forceHeight: Bool, _ smooth: Bool) {
        // TODO: Port CCMLandScape::FlattenArea
        portMissing("CCMLandScape::FlattenArea", source: "oracle/codemp/qcommon/cm_terrain.cpp:1312")
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1133
    func CarveLine(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ depth: Int32, _ width: Int32) {
        // TODO: Port CCMLandScape::CarveLine
        portMissing("CCMLandScape::CarveLine", source: "oracle/codemp/qcommon/cm_terrain.cpp:1133")
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1245
    // AI: Raven reads `numCtlPoints` vectors through `vec3_t *ctlPoints`. The parameter is the caller's array, the PARAMS kind `vec3_array`.
    func CarveBezierCurve(_ numCtlPoints: Int32, _ ctlPoints: [JKAShared.vec3_t], _ steps: Int32, _ depth: Int32, _ size: Int32) {
        // TODO: Port CCMLandScape::CarveBezierCurve
        portMissing("CCMLandScape::CarveBezierCurve", source: "oracle/codemp/qcommon/cm_terrain.cpp:1245")
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1128
    func SaveArea(_ area: CArea?) {
        // TODO: Port CCMLandScape::SaveArea
        portMissing("CCMLandScape::SaveArea", source: "oracle/codemp/qcommon/cm_terrain.cpp:1128")
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1379
    func FractionBelowLevel(_ area: CArea?, _ height: Int32) -> Float {
        // TODO: Port CCMLandScape::FractionBelowLevel
        portMissing("CCMLandScape::FractionBelowLevel", source: "oracle/codemp/qcommon/cm_terrain.cpp:1379")
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1488
    // AI: Raven reads `areaTypeCount` types through `int *areaTypes`. The parameter is the caller's array, the PARAMS kind `int_array`.
    func AreaCollision(_ area: CArea?, _ areaTypes: [Int32]?, _ areaTypeCount: Int32) -> Bool {
        // TODO: Port CCMLandScape::AreaCollision
        portMissing("CCMLandScape::AreaCollision", source: "oracle/codemp/qcommon/cm_terrain.cpp:1488")
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1412
    func GetFirstArea() -> CArea? {
        // TODO: Port CCMLandScape::GetFirstArea
        portMissing("CCMLandScape::GetFirstArea", source: "oracle/codemp/qcommon/cm_terrain.cpp:1412")
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1422
    func GetFirstObjectiveArea() -> CArea? {
        // TODO: Port CCMLandScape::GetFirstObjectiveArea
        portMissing("CCMLandScape::GetFirstObjectiveArea", source: "oracle/codemp/qcommon/cm_terrain.cpp:1422")
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1442
    func GetPlayerArea() -> CArea? {
        // TODO: Port CCMLandScape::GetPlayerArea
        portMissing("CCMLandScape::GetPlayerArea", source: "oracle/codemp/qcommon/cm_terrain.cpp:1442")
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1462
    func GetNextArea() -> CArea? {
        // TODO: Port CCMLandScape::GetNextArea
        portMissing("CCMLandScape::GetNextArea", source: "oracle/codemp/qcommon/cm_terrain.cpp:1462")
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1472
    func GetNextObjectiveArea() -> CArea? {
        // TODO: Port CCMLandScape::GetNextObjectiveArea
        portMissing("CCMLandScape::GetNextObjectiveArea", source: "oracle/codemp/qcommon/cm_terrain.cpp:1472")
    }

    // Accessors
    /// Source: oracle/codemp/qcommon/cm_landscape.h:196
    func GetRefCount() -> Int32 {
        self.mRefCount
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:197
    func IncreaseRefCount() {
        self.mRefCount += 1
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:198
    func DecreaseRefCount() {
        self.mRefCount -= 1
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:199
    func GetBounds() -> [JKAShared.vec3_t] {
        self.mBounds
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:200
    func GetMins() -> JKAShared.vec3_t {
        self.mBounds[0]
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:201
    func GetMaxs() -> JKAShared.vec3_t {
        self.mBounds[1]
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:202
    func GetSize() -> JKAShared.vec3_t {
        self.mSize
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:203
    func GetTerxelSize() -> JKAShared.vec3_t {
        self.mTerxelSize
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:204
    func GetPatchSize() -> JKAShared.vec3_t {
        self.mPatchSize
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:205
    func GetPatchWidth() -> Float {
        self.mPatchSize[0]
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:206
    func GetPatchHeight() -> Float {
        self.mPatchSize[1]
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:207
    func GetPatchScalarSize() -> Float {
        self.mPatchScalarSize
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:208
    func GetTerxels() -> Int32 {
        self.mTerxels
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:209
    func GetRealWidth() -> Int32 {
        self.mWidth + 1
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:210
    func GetRealHeight() -> Int32 {
        self.mHeight + 1
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:211
    func GetRealArea() -> Int32 {
        (self.mWidth + 1) * (self.mHeight + 1)
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:212
    func GetWidth() -> Int32 {
        self.mWidth
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:213
    func GetHeight() -> Int32 {
        self.mHeight
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:214
    func GetArea() -> Int32 {
        self.mWidth * self.mHeight
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:215
    func GetBlockWidth() -> Int32 {
        self.mBlockWidth
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:216
    func GetBlockHeight() -> Int32 {
        self.mBlockHeight
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:217
    func GetBlockCount() -> Int32 {
        self.mBlockWidth * self.mBlockHeight
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:218
    func GetHeightMap() -> Slots<JKAShared.byte>? {
        self.mHeightMap
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:219
    func GetFlattenMap() -> Slots<JKAShared.byte>? {
        self.mFlattenMap
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:220
    func GetTerrainId() -> JKAShared.thandle_t {
        self.mTerrainHandle
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:221
    func SetTerrainId(_ terrainId: JKAShared.thandle_t) {
        self.mTerrainHandle = terrainId
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:222
    // C converts the `int` height to `float` at the multiply.
    func CalcWorldHeight(_ height: Int32) -> Float {
        (Float(height) * self.mTerxelSize[2]) + self.mBounds[0][2]
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:223
    func GetHasPhysics() -> Bool {
        self.mHasPhysics
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:224
    func GetIsRandom() -> Bool {
        // TODO: Port CCMLandScape::GetIsRandom
        portMissing("CCMLandScape::GetIsRandom", source: "oracle/codemp/qcommon/cm_landscape.h:224")
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:225
    func GetSurfaceFlags(_ height: Int32) -> Int32 {
        self.mHeightDetails[height].GetSurfaceFlags()
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:226
    func GetContentFlags(_ height: Int32) -> Int32 {
        self.mHeightDetails[height].GetContents()
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:975
    func CalcRealCoords() {
        // TODO: Port CCMLandScape::CalcRealCoords
        portMissing("CCMLandScape::CalcRealCoords", source: "oracle/codemp/qcommon/cm_terrain.cpp:975")
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:228
    func GetCoords() -> Slots<JKAShared.vec3_t>? {
        self.mCoords
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:230
    func GetBaseWaterHeight() -> Int32 {
        self.mBaseWaterHeight
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:231
    // C converts the `int` height to `float` at the multiply.
    func SetRealWaterHeight(_ height: Int32) {
        self.mWaterHeight = Float(height) * self.mTerxelSize[2]
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:232
    func GetWaterHeight() -> Float {
        self.mWaterHeight
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:233
    func GetWaterContents() -> Int32 {
        self.mWaterContents
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:234
    func GetWaterSurfaceFlags() -> Int32 {
        self.mWaterSurfaceFlags
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:236
    // TODO: Port signature
    // Raven wrote: CRandomTerrain			*GetRandomTerrain(void) { return mRandomTerrain; }
    // No table row for the return `CRandomTerrain *`.
    func GetRandomTerrain() -> Never {
        // TODO: Port CCMLandScape::GetRandomTerrain
        portMissing("CCMLandScape::GetRandomTerrain", source: "oracle/codemp/qcommon/cm_landscape.h:236")
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1548
    func rand_seed(_ seed: Int32) {
        // TODO: Port CCMLandScape::rand_seed
        portMissing("CCMLandScape::rand_seed", source: "oracle/codemp/qcommon/cm_terrain.cpp:1548")
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:239
    func get_rand_seed() -> UInt32 {
        self.holdrand
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1554
    func flrand(_ min: Float, _ max: Float) -> Float {
        // TODO: Port CCMLandScape::flrand
        portMissing("CCMLandScape::flrand", source: "oracle/codemp/qcommon/cm_terrain.cpp:1554")
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1568
    func irand(_ min: Int32, _ max: Int32) -> Int32 {
        // TODO: Port CCMLandScape::irand
        portMissing("CCMLandScape::irand", source: "oracle/codemp/qcommon/cm_terrain.cpp:1568")
    }
}
