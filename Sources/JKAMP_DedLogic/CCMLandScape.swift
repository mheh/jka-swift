import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's collision terrain of a map, the height map, its patches and their brushes, the water, and the flattened areas.
/// `CM_RegisterTerrain` makes the one instance, `cmg.landScape`, and the trace of a terrain brush and the random mission read it.
/// Source: oracle/codemp/qcommon/cm_landscape.h:135
public final class CCMLandScape {
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
    private var mRandomTerrain: CRandomTerrain? = nil

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
        var numPatches: Int32
        var numBrushesPerPatch: Int32
        var size: Int32
        var seed: Int32
        var heightMap = CharBuf(MAX_QPATH)
        var ptr: Int32 = 0

        self.holdrand = 0x89abcdef

        // Clear out the height details
        // AI: Raven zeroes the HEIGHT_RESOLUTION records with memset. The field initializer already gives zero records, so the call drops.
        self.mBaseWaterHeight = 0
        self.mWaterHeight = 0.0

        // When constructed, referenced once
        self.mRefCount = 1

        // Extract the relevant data from the config string
        Com_sprintf(&heightMap, MAX_QPATH, "%s", Info_ValueForKey(configstring, "heightMap"))
        numPatches = atoi(Info_ValueForKey(configstring, "numPatches"))
        self.mTerxels = atoi(Info_ValueForKey(configstring, "terxels"))
        self.mHasPhysics = atoi(Info_ValueForKey(configstring, "physics")) != 0
        // C converts the `unsigned long` to the `int` local by its bits.
        seed = Int32(bitPattern: strtoul(Info_ValueForKey(configstring, "seed"), &ptr, 10))

        self.mBounds[0][0] = Float(atof(Info_ValueForKey(configstring, "minx")))
        self.mBounds[0][1] = Float(atof(Info_ValueForKey(configstring, "miny")))
        self.mBounds[0][2] = Float(atof(Info_ValueForKey(configstring, "minz")))
        self.mBounds[1][0] = Float(atof(Info_ValueForKey(configstring, "maxx")))
        self.mBounds[1][1] = Float(atof(Info_ValueForKey(configstring, "maxy")))
        self.mBounds[1][2] = Float(atof(Info_ValueForKey(configstring, "maxz")))

        // Calculate size of the brush
        self.mSize = self.mBounds[1] - self.mBounds[0]

        // Work out the dimensions of the brush in blocks - the object is to make the blocks as square as possible
        self.mBlockWidth = Round(sqrtf(numPatches * self.mSize[0] / self.mSize[1]))
        self.mBlockHeight = Round(sqrtf(numPatches * self.mSize[1] / self.mSize[0]))

        // ...which lets us get the size of the heightmap
        self.mWidth = self.mBlockWidth * self.mTerxels
        self.mHeight = self.mBlockHeight * self.mTerxels

        self.mHeightMap = Slots<JKAShared.byte>(scalars: Z_Malloc(self.GetRealArea(), TAG_CM_TERRAIN), count: Int(self.GetRealArea()))
        self.mFlattenMap = Slots<JKAShared.byte>(scalars: Z_Malloc(self.GetRealArea(), TAG_CM_TERRAIN), count: Int(self.GetRealArea()))

        // Zero means unused.
        self.mFlattenMap!.zero()

        if strlen(heightMap) != 0 {
            var imageData: Slots<JKAShared.byte>?

            Com_DPrintf("CM_Terrain: Loading heightmap %s.....\n", heightMap)
            self.mRandomTerrain = nil
            imageData = nil
        } else {
            Com_Error(ERR_FATAL, "Terrain has no heightmap specified\n")
        }

        // Work out the dimensions of the terxel - should be almost square
        self.mTerxelSize[0] = self.mSize[0] / self.mWidth
        self.mTerxelSize[1] = self.mSize[1] / self.mHeight
        self.mTerxelSize[2] = self.mSize[2] / 255.0

        // Work out the patchsize
        self.mPatchSize[0] = self.mSize[0] / self.mBlockWidth
        self.mPatchSize[1] = self.mSize[1] / self.mBlockHeight
        self.mPatchSize[2] = 1.0
        self.mPatchScalarSize = VectorLength(self.mPatchSize)

        // Loads in the water height and properties
        // Gets the shader properties for the blended shaders
        self.LoadTerrainDef(configstring)

        Com_DPrintf("CM_Terrain: Creating patches.....\n")
        // AI: Raven allocates the patches as one Z_Malloc block. The array takes GetBlockCount new patches, the form of the field `mHeightDetails`.
        self.mPatches = (0..<self.GetBlockCount()).map { _ in CCMPatch() }

        numBrushesPerPatch = self.mTerxels * self.mTerxels * 2
        size = (numBrushesPerPatch * Int32(Cbrush.byteCount)) + (numBrushesPerPatch * BRUSH_SIDES_PER_TERXEL * 2 * (Int32(Cbrushside.byteCount) + Int32(JKAShared.Cplane.byteCount)))
        self.mPatchBrushData = Slots<JKAShared.byte>(scalars: Z_Malloc(size * self.GetBlockCount(), TAG_CM_TERRAIN), count: Int(size * self.GetBlockCount()))

        // Initialize all terrain patches
        self.UpdatePatches()
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1583
    deinit {
        if self.mHeightMap != nil {
            Z_Free(OpaquePointer(self.mHeightMap!.base))
            self.mHeightMap = nil
        }
        if self.mFlattenMap != nil {
            Z_Free(OpaquePointer(self.mFlattenMap!.base))
            self.mFlattenMap = nil
        }
        if self.mPatchBrushData != nil {
            Z_Free(OpaquePointer(self.mPatchBrushData!.base))
            self.mPatchBrushData = nil
        }
        if !self.mPatches.isEmpty {
            // AI: Raven frees the patch block with Z_Free. Emptying the array frees the patches.
            self.mPatches = []
        }
        if self.mRandomTerrain != nil {
            // AI: Raven deletes the random terrain. The store of nil releases the class, and its deinit runs Raven's destructor.
            self.mRandomTerrain = nil
        }

        // AI: Raven deletes each area through the iterator. The clear below frees them.
        self.mAreas.removeAll()
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:593
    func GetPatch(_ x: Int32, _ y: Int32) -> CCMPatch? {
        return (self.mPatches[(y * self.mBlockWidth) + x])
    }

    // Prototypes
    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:600
    func PatchCollide(_ tw: TraceWork, _ trace: JKAMP.Trace, _ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ checkcount: Int32) {
        var tBounds: [JKAShared.vec3_t] = [JKAShared.vec3_t(), JKAShared.vec3_t()]

        // Convert to valid bounding box
        CM_CalcExtents(start, end, tw, &tBounds)

        //if (com_newtrace->integer)
        if 1 != 0 {
            var slope: Float
            var offset: Float
            var startPatchLoc: Float
            var endPatchLoc: Float
            var startPos: Float
            var endPos: Float
            var patchDirection: Float = 1
            var checkDirection: Float = 1
            var countPatches: Int32
            var count: Int32
            var patch: CCMPatch?
            let fraction: Float = trace.fraction

            if abs(end[0] - start[0]) >= abs(abs(end[1] - start[1])) {
                // x travels more than y
                // calculate line slope and offset
                if (end[0] - start[0]) != 0 {
                    slope = (end[1] - start[1]) / (end[0] - start[0])
                } else {
                    slope = 0
                }
                offset = start[1] - (start[0] * slope)

                // find the starting
                startPatchLoc = floor((start[0] - self.mBounds[0][0]) / self.mPatchSize[0])
                endPatchLoc = floor((end[0] - self.mBounds[0][0]) / self.mPatchSize[0])

                if startPatchLoc <= endPatchLoc {
                    // moving along slope in a positive direction
                    endPatchLoc += 1
                    startPatchLoc -= 1
                    countPatches = Int32(endPatchLoc - startPatchLoc + 1)
                } else {
                    // moving along slope in a negative direction
                    endPatchLoc -= 1
                    startPatchLoc += 1
                    patchDirection = -1
                    countPatches = Int32(startPatchLoc - endPatchLoc + 1)
                }
                if Double(slope) < 0.0 {
                    checkDirection = -1
                }

                // first calculate the real world location
                startPos = ((startPatchLoc * self.mPatchSize[0] + self.mBounds[0][0]) * slope) + offset
                // calculate it back into patch coords
                startPos = floor((startPos - self.mBounds[0][1] + tw.size[0][1]) / self.mPatchSize[1])
                repeat {
                    if startPatchLoc >= 0 && startPatchLoc < self.mBlockWidth {
                        // valid location
                        // first calculate the real world location
                        endPos = (((startPatchLoc + patchDirection) * self.mPatchSize[0] + self.mBounds[0][0]) * slope) + offset
                        // calculate it back into patch coords
                        endPos = floor((endPos - self.mBounds[0][1] + tw.size[1][1]) / self.mPatchSize[1])

                        if checkDirection < 0 {
                            startPos += 1
                            endPos -= 1
                        } else {
                            startPos -= 1
                            endPos += 1
                        }
                        count = Int32(abs(endPos - startPos) + 1)
                        while count != 0 {
                            if startPos >= 0 && startPos < self.mBlockHeight {
                                // valid location
                                patch = self.GetPatch(Int32(startPatchLoc), Int32(startPos))
                                // Collide with every patch to find the minimum fraction
                                CM_HandlePatchCollision(tw, trace, tBounds[0], tBounds[1], patch, checkcount)

                                if Double(trace.fraction) <= 0.0 {
                                    return
                                }
                            }
                            startPos += checkDirection
                            count -= 1
                        }

                        if trace.fraction < fraction {
                            return
                        }
                    }
                    // move to the next spot
                    // we still stay one behind, to get the opposite edge of the terrain patch
                    startPos = ((startPatchLoc * self.mPatchSize[0] + self.mBounds[0][0]) * slope) + offset
                    startPatchLoc += patchDirection
                    // first calculate the real world location
                    // calculate it back into patch coords
                    startPos = floor((startPos - self.mBounds[0][1] + tw.size[0][1]) / self.mPatchSize[1])

                    countPatches -= 1
                } while countPatches != 0
            } else {
                // calculate line slope and offset
                slope = (end[0] - start[0]) / (end[1] - start[1])
                offset = start[0] - (start[1] * slope)

                // find the starting
                startPatchLoc = floor((start[1] - self.mBounds[0][1]) / self.mPatchSize[1])
                endPatchLoc = floor((end[1] - self.mBounds[0][1]) / self.mPatchSize[1])

                if startPatchLoc <= endPatchLoc {
                    // moving along slope in a positive direction
                    endPatchLoc += 1
                    startPatchLoc -= 1
                    countPatches = Int32(endPatchLoc - startPatchLoc + 1)
                } else {
                    // moving along slope in a negative direction
                    endPatchLoc -= 1
                    startPatchLoc += 1
                    patchDirection = -1
                    countPatches = Int32(startPatchLoc - endPatchLoc + 1)
                }
                if Double(slope) < 0.0 {
                    checkDirection = -1
                }

                // first calculate the real world location
                startPos = ((startPatchLoc * self.mPatchSize[1] + self.mBounds[0][1]) * slope) + offset
                // calculate it back into patch coords
                startPos = floor((startPos - self.mBounds[0][0] + tw.size[0][0]) / self.mPatchSize[0])
                repeat {
                    if startPatchLoc >= 0 && startPatchLoc < self.mBlockHeight {
                        // valid location
                        // first calculate the real world location
                        endPos = (((startPatchLoc + patchDirection) * self.mPatchSize[1] + self.mBounds[0][1]) * slope) + offset
                        // calculate it back into patch coords
                        endPos = floor((endPos - self.mBounds[0][0] + tw.size[1][0]) / self.mPatchSize[0])

                        if checkDirection < 0 {
                            startPos += 1
                            endPos -= 1
                        } else {
                            startPos -= 1
                            endPos += 1
                        }

                        count = Int32(abs(endPos - startPos) + 1)
                        while count != 0 {
                            if startPos >= 0 && startPos < self.mBlockWidth {
                                // valid location
                                patch = self.GetPatch(Int32(startPos), Int32(startPatchLoc))
                                // Collide with every patch to find the minimum fraction
                                CM_HandlePatchCollision(tw, trace, tBounds[0], tBounds[1], patch, checkcount)

                                if Double(trace.fraction) <= 0.0 {
                                    return
                                }
                            }
                            startPos += checkDirection
                            count -= 1
                        }

                        if trace.fraction < fraction {
                            return
                        }
                    }

                    // move to the next spot
                    // we still stay one behind, to get the opposite edge of the terrain patch
                    startPos = ((startPatchLoc * self.mPatchSize[1] + self.mBounds[0][1]) * slope) + offset
                    startPatchLoc += patchDirection
                    // first calculate the real world location
                    // calculate it back into patch coords
                    startPos = floor((startPos - self.mBounds[0][0] + tw.size[0][0]) / self.mPatchSize[0])
                    countPatches -= 1
                } while countPatches != 0
            }
        } else {
            var x: Int32
            var y: Int32
            var tWork = JKAShared.vec3_t()
            var pStart = JKAShared.vec3_t()
            var pEnd = JKAShared.vec3_t()
            var minx: Int32
            var maxx: Int32
            var miny: Int32
            var maxy: Int32
            var patch: CCMPatch?

            // Work out and grab the relevant patches
            tWork = tBounds[0] - self.mBounds[0]
            // Raven's VectorInverseScaleVector macro of q_shared.h expands here, because the port has no function for it.
            pStart[0] = tWork[0] / self.mPatchSize[0]
            pStart[1] = tWork[1] / self.mPatchSize[1]
            pStart[2] = tWork[2] / self.mPatchSize[2]
            tWork = tBounds[1] - self.mBounds[0]
            pEnd[0] = tWork[0] / self.mPatchSize[0]
            pEnd[1] = tWork[1] / self.mPatchSize[1]
            pEnd[2] = tWork[2] / self.mPatchSize[2]

            minx = Int32(Com_Clamp(0, Float(self.mBlockWidth - 1), floorf(pStart[0])))
            maxx = Int32(Com_Clamp(0, Float(self.mBlockWidth - 1), ceilf(pEnd[0])))
            miny = Int32(Com_Clamp(0, Float(self.mBlockHeight - 1), floorf(pStart[1])))
            maxy = Int32(Com_Clamp(0, Float(self.mBlockHeight - 1), ceilf(pEnd[1])))

            // generic box collide with each one
            y = miny
            while y <= maxy {
                x = minx
                while x <= maxx {
                    patch = self.GetPatch(x, y)
                    // Collide with every patch to find the minimum fraction
                    CM_HandlePatchCollision(tw, trace, tBounds[0], tBounds[1], patch, checkcount)

                    if Double(trace.fraction) <= 0.0 {
                        break
                    }
                    x += 1
                }
                y += 1
            }
        }
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:997
    func TerrainPatchIterate(_ IterateFunc: ((CCMPatch?, OpaquePointer?) -> Void)?, _ userdata: OpaquePointer?) {
        var i: Int32
        var patchIndex: Int32

        // AI: Raven walks the patch block with the pointer `patch`. The walk is the index `patchIndex` into the array.
        patchIndex = 0
        i = 0
        while i < self.GetBlockCount() {
            IterateFunc!(self.mPatches[patchIndex], userdata)
            i += 1
            patchIndex += 1
        }
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1011
    func GetWorldHeight(_ origin: inout JKAShared.vec3_t, _ bounds: [JKAShared.vec3_t], _ aboveGround: Bool) -> Float {
        var work = JKAShared.vec3_t()
        var minx: Int32
        var maxx: Int32
        var miny: Int32
        var maxy: Int32
        var TL: Int32
        var TR: Int32
        var BL: Int32
        var BR: Int32
        var `final`: Int32

        work = origin - self.mBounds[0]
        // Raven's VectorInverseScaleVector macro of q_shared.h expands here, because the port has no function for it.
        work[0] = work[0] / self.mTerxelSize[0]
        work[1] = work[1] / self.mTerxelSize[1]
        work[2] = work[2] / self.mTerxelSize[2]

        // Presume the bases of all misc models are less than 1 terxel square
        minx = Int32(Com_Clamp(0, Float(self.GetWidth()), Float(Int32(floorf(work[0])))))
        maxx = Int32(Com_Clamp(0, Float(self.GetWidth()), Float(Int32(ceilf(work[0])))))
        miny = Int32(Com_Clamp(0, Float(self.GetHeight()), Float(Int32(floorf(work[1])))))
        maxy = Int32(Com_Clamp(0, Float(self.GetHeight()), Float(Int32(ceilf(work[1])))))

        // C widens the unsigned byte to `int` at each store.
        TL = Int32(self.mHeightMap![(miny * self.GetRealWidth()) + minx])
        TR = Int32(self.mHeightMap![(miny * self.GetRealWidth()) + maxx])
        BL = Int32(self.mHeightMap![(maxy * self.GetRealWidth()) + minx])
        BR = Int32(self.mHeightMap![(maxy * self.GetRealWidth()) + maxx])

        if aboveGround {
            //		int			max1, max2;
            //		max1 = maximum(TL, TR);
            //		max2 = maximum(BL, BR);
            //		final = maximum(max1, max2);
            var h1: Float
            var h2: Float
            var tx: Float
            var ty: Float
            tx = (work[0] - minx) / (Float(maxx - minx))
            ty = (work[1] - miny) / (Float(maxy - miny))
            // Raven's LERP macro of this file expands at each site, because the stub has no function for it.
            h1 = ((TR - TL) * tx + TL)
            h2 = ((BR - BL) * tx + BL)
            `final` = Int32((h2 - h1) * ty + h1)
        } else {
            var min1: Int32
            var min2: Int32

            // Raven's minimum macro of q_shared.h expands at each site, because the port has no function for it.
            min1 = (TL < TR ? TL : TR)
            min2 = (BL < BR ? BL : BR)
            `final` = (min1 < min2 ? min1 : min2)
        }
        origin[2] = (`final` * self.mTerxelSize[2]) + self.mBounds[0][2]

        // compute slope at this spot
        if maxx == minx {
            maxx = Int32(Com_Clamp(0, Float(self.GetWidth()), Float(minx + 1)))
        }
        if maxy == miny {
            maxy = Int32(Com_Clamp(0, Float(self.GetHeight()), Float(miny + 1)))
        }
        BR = Int32(self.mHeightMap![(maxy * self.GetRealWidth()) + maxx])

        // rise over run
        return (abs(Float(BR - TL)) * self.mTerxelSize[2]) / self.mTerxelSize[0]
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:836
    func WaterCollide(_ begin: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ fraction: Float) -> Float {
        // Raven assigns his own `fraction` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
        var fraction = fraction

        // Check for completely above water
        if (begin[2] > self.mWaterHeight) && (end[2] > self.mWaterHeight) {
            return (fraction)
        }
        // Check for completely below water
        if (begin[2] < self.mWaterHeight) && (end[2] < self.mWaterHeight) {
            return (fraction)
        }
        // Check for starting in water and leaving
        if Double(begin[2]) < Double(self.mWaterHeight) - SURFACE_CLIP_EPSILON {
            fraction = Float(((Double(self.mWaterHeight) - SURFACE_CLIP_EPSILON) - Double(begin[2])) / Double(end[2] - begin[2]))
            return (fraction)
        }
        // Now the trace must be entering the water
        if Double(begin[2]) > Double(self.mWaterHeight) + SURFACE_CLIP_EPSILON {
            fraction = Float((Double(begin[2]) - (Double(self.mWaterHeight) + SURFACE_CLIP_EPSILON)) / Double(begin[2] - end[2]))
        }
        return (fraction)
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:898
    func UpdatePatches() {
        var x: Int32
        var y: Int32
        var ix: Int32
        var iy: Int32
        var numBrushesPerPatch: Int32
        var world = JKAShared.vec3_t()
        var size: Int32
        var patchIndex: Int32

        /*	for(y=0;y<GetRealHeight();y++)
        	{
        		for(x=0;x<GetRealWidth();x++)
        		{
        			Com_Printf("(%d,%d) = %u\n", x, y, (unsigned)mHeightMap[y*GetRealWidth() + x]);
        		}
        	}
        */
        // Calculate real world coordinates from the heightmap
        self.CalcRealCoords()

        numBrushesPerPatch = self.mTerxels * self.mTerxels * 2
        size = (numBrushesPerPatch * Int32(Cbrush.byteCount)) + (numBrushesPerPatch * BRUSH_SIDES_PER_TERXEL * 2 * (Int32(Cbrushside.byteCount) + Int32(JKAShared.Cplane.byteCount)))

        // AI: Raven walks the patch block with the pointer `patch`. The walk is the index `patchIndex` into the array.
        patchIndex = 0
        y = 0
        iy = 0
        while y < self.mHeight {
            x = 0
            ix = 0
            while x < self.mWidth {
                world = JKAShared.vec3_t(self.mBounds[0][0] + (x * self.mTerxelSize[0]), self.mBounds[0][1] + (y * self.mTerxelSize[1]), self.mBounds[0][2])
                // AI: Raven passes the bytes of the patch, and Init casts them at cm_terrain.cpp:588. The cast moves to the call, with the brush count of a patch.
                self.mPatches[patchIndex].Init(self, x, y, world, self.mHeightMap, Slots<Cbrush>(self.mPatchBrushData!.suffix(from: size * (ix + (iy * self.mBlockWidth))).base, count: numBrushesPerPatch))
                x += self.mTerxels
                ix += 1
                patchIndex += 1
            }
            y += self.mTerxels
            iy += 1
        }

        /*
        	for ( y = mTerxels; y < mHeight - mTerxels; y ++ )
        	{
        		for ( x = mTerxels; x < mWidth - mTerxels; x ++ )
        		{
        			int xo     = x % mTerxels;
        			int yo     = y % mTerxels;
        			int xor    = (x + 1) % mTerxels;
        			int yob    = (y + 1) % mTerxels;

        			CCMPatch*	patch  = mPatches + (mWidth / mTerxels) * y + (x / mTerxels);
        			CCMPatch*	rpatch = mPatches + (mWidth / mTerxels) * y + ((x+1) / mTerxels);
        			CCMPatch*	bpatch = mPatches + (mWidth / mTerxels) * (y + 1) + (x / mTerxels);

        			int		offsets[4];
        			vec3_t	localCoords[8];
        			vec3_t	localCoordsR[8];
        			vec3_t	localCoordsL[8];

        			GetTerxelLocalCoords ( x, y, localCoords );
        			GetTerxelLocalCoords ( x + 1, y, localCoordsR );
        			GetTerxelLocalCoords ( x, y + 1, localCoordsB );

        			brush = patch->GetCollisionData ( );;
        			side  = (cbrushside_t *)(mPatchBrushData + patch->GetNumBrushes ( ) );
        			plane = (cplane_t *)(side + (mNumBrushes * BRUSH_SIDES_PER_TERXEL * 2));


        			float V = DotProduct ( (plane + 8)->normal, localCoords[0] ) + plane->dist;

        			if ( V < 0 )
        			{
        				InitPlane ( brush[0].sides + brush[0].numsides, plane + brush[0].numsides, localCoords[3], localCoords[2], localCoords[1]);
        				brush[0].numsides++;

        				InitPlane ( brush[1].sides + brush[1].numsides, plane + 8 + brush[1].numsides, localCoords[0], localCoords[1], localCoords[2]);
        				brush[1].numsides++;
        			}
        		}
        	}
        */

        // Cleanup coord array
        Z_Free(OpaquePointer(self.mCoords!.base))
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:862
    // AI: Raven fills the caller's `vec3_t coords[8]`. The parameter is the Slots over the vectors, the PARAMS kind `table` of a `vec3_t *`.
    func GetTerxelLocalCoords(_ x: Int32, _ y: Int32, _ localCoords: Slots<JKAShared.vec3_t>) {
        // Raven's one call is in the comment block of UpdatePatches at cm_terrain.cpp:948, and no file of either tree calls it, so the function is dead.
        var realWidth: Int32
        var coords: Slots<JKAShared.vec3_t>?
        var offsets = [Int32](repeating: 0, count: 4)
        var i: Int32

        coords = self.GetCoords()
        realWidth = self.GetRealWidth()

        if ((x + y) & 1) != 0 {
            offsets[0] = (y * realWidth) + x				// TL
            offsets[1] = (y * realWidth) + x + 1			// TR
            offsets[2] = ((y + 1) * realWidth) + x			// BL
            offsets[3] = ((y + 1) * realWidth) + x + 1		// BR
        } else {
            offsets[2] = (y * realWidth) + x				// TL
            offsets[0] = (y * realWidth) + x + 1			// TR
            offsets[3] = ((y + 1) * realWidth) + x			// BL
            offsets[1] = ((y + 1) * realWidth) + x + 1		// BR
        }

        i = 0
        while i < 4 {
            localCoords[i] = coords![offsets[i]]
            localCoords[i + 4] = coords![offsets[i]]

            // Set z of base of brush to bottom of landscape brush
            localCoords[i + 4][2] = self.GetMins()[2]
            i += 1
        }
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:39
    func LoadTerrainDef(_ td: String) {
        var terrainDef = CharBuf(MAX_QPATH)
        let parse = CGenericParser2()
        var basegroup: CGPGroup?
        var classes: CGPGroup?
        var items: CGPGroup?

        Com_sprintf(&terrainDef, MAX_QPATH, "ext_data/RMG/%s.terrain", Info_ValueForKey(td, "terrainDef"))
        Com_DPrintf("CM_Terrain: Loading and parsing terrainDef %s.....\n", Info_ValueForKey(td, "terrainDef"))

        if !Com_ParseTextFile(String(terrainDef), parse) {
            Com_sprintf(&terrainDef, MAX_QPATH, "ext_data/arioche/%s.terrain", Info_ValueForKey(td, "terrainDef"))
            if !Com_ParseTextFile(String(terrainDef), parse) {
                Com_Printf("Could not open %s\n", terrainDef)
                return
            }
        }
        // The whole file....
        basegroup = parse.GetBaseParseGroup()

        // The root { } struct
        classes = basegroup!.GetSubGroups()
        while classes != nil {
            items = classes!.GetSubGroups()
            while items != nil {
                if Q_stricmp(items!.GetName(), "altitudetexture") == 0 {
                    var height: Int32
                    var shaderName: String?
                    var shader: CmShader?

                    // Height must exist - the rest are optional
                    height = atoi(items!.FindPairValue("height", "0")!)

                    // Shader for this height
                    shaderName = items!.FindPairValue("shader", "")
                    if strlen(shaderName!) != 0 {
                        shader = CM_GetShaderInfo(shaderName!)
                        if shader != nil {
                            self.SetShaders(height, shader)
                        }
                    }
                } else if Q_stricmp(items!.GetName(), "water") == 0 {
                    var shaderName: String?
                    var shader: CmShader?

                    // Grab the height of the water
                    self.mBaseWaterHeight = atoi(items!.FindPairValue("height", "0")!)
                    self.SetRealWaterHeight(self.mBaseWaterHeight)

                    // Grab the material of the water
                    shaderName = items!.FindPairValue("shader", "")
                    shader = CM_GetShaderInfo(shaderName!)
                    if shader != nil {
                        self.mWaterContents = shader!.contentFlags
                        self.mWaterSurfaceFlags = shader!.surfaceFlags
                    }
                }
                items = items!.GetNext()
            }
            classes = classes!.GetNext()
        }
        Com_ParseTextFileDestroy(parse)
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:26
    func SetShaders(_ height: Int32, _ shader: CmShader?) {
        var i: Int32

        i = height
        while shader != nil && (i < HEIGHT_RESOLUTION) {
            if self.mHeightDetails[i].GetSurfaceFlags() == 0 {
                self.mHeightDetails[i].SetFlags(shader!.contentFlags, shader!.surfaceFlags)
            }
            i += 1
        }
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1312
    func FlattenArea(_ area: CArea?, _ height: Int32, _ save: Bool, _ forceHeight: Bool, _ smooth: Bool) {
        // Raven assigns his own `height` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
        var height = height
        var temp = JKAShared.vec3_t()
        var icoords = [Int32](repeating: 0, count: 3)
        var radius: Int32
        var height2: Int32

        if save {
            self.SaveArea(area)
            //	mAreas.push_back(*area);
        }

        // Work out coords in the heightmap
        temp = area!.GetPosition() - self.mBounds[0]
        icoords[0] = Int32(temp[0] / (self.mBounds[1][0] - self.mBounds[0][0]) * Float(self.GetRealWidth()))
        icoords[1] = Int32(temp[1] / (self.mBounds[1][1] - self.mBounds[0][1]) * Float(self.GetRealHeight()))

        //	VectorInverseScaleVector(temp, mTerxelSize, icoords);

        // round up, we'd rather have a little more area flattened than have less then what was requested
        radius = Int32(ceilf((area!.GetRadius() / self.mTerxelSize[1])))

        // Work out the average height of the surrounding terrain
        height2 = height
        if height < 0 {
            // AI: Raven declares `ivec3_t info` on his stack. The body uses the zeroed allocation of the storage class through the `info_FlattenArea` forward.
            info_FlattenArea[0] = 0
            info_FlattenArea[1] = 0
            CM_CircularIterate(self.mHeightMap!, self.GetRealWidth(), self.GetRealHeight(), icoords[0], icoords[1], 0, radius, info_FlattenArea, CM_GetAverage)
            if info_FlattenArea[1] != 0 {
                height = info_FlattenArea[0] / info_FlattenArea[1]
            }
        } else {
            height = height & 0x7F
        }

        // AI: Raven hands on the addresses of `height` and `height2`. The body copies each into its storage slot and hands on the slot.
        height_FlattenArea[0] = height
        height2_FlattenArea[0] = height2

        if smooth {
            CM_CircularIterate(self.mHeightMap!, self.GetRealWidth(), self.GetRealHeight(), icoords[0], icoords[1], radius, radius * 3, height_FlattenArea, CM_Smooth)
        }

        if forceHeight {
            CM_CircularIterate(self.mHeightMap!, self.GetRealWidth(), self.GetRealHeight(), icoords[0], icoords[1], 0, radius + 1, height_FlattenArea, CM_ForceHeight)
            CM_CircularIterate(self.mFlattenMap!, self.GetRealWidth(), self.GetRealHeight(), icoords[0], icoords[1], 0, radius + 1, height2_FlattenArea, CM_ForceHeight)
        } else if smooth {
            CM_CircularIterate(self.mHeightMap!, self.GetRealWidth(), self.GetRealHeight(), icoords[0], icoords[1], 0, radius, height_FlattenArea, CM_Smooth)
        }
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1133
    func CarveLine(_ start: JKAShared.vec3_t, _ end: JKAShared.vec3_t, _ depth: Int32, _ width: Int32) {
        // Raven's one call is in CarveBezierCurve, which is dead, so the function is dead too.
        var x: Int32
        var x1: Int32
        var x2: Int32
        var deltax: Int32
        var y: Int32
        var y1: Int32
        var y2: Int32
        var deltay: Int32
        var xinc1: Int32
        var xinc2: Int32
        var yinc1: Int32
        var yinc2: Int32
        var den: Int32
        var num: Int32
        var count: Int32
        var add: Int32
        var i: Int32
        var heightStart: Float
        var heightEnd: Float
        var heightStep: Float

        x1 = Int32(start[0])
        y1 = Int32(start[1])
        x2 = Int32(end[0])
        y2 = Int32(end[1])

        deltax = abs(x2 - x1)
        deltay = abs(y2 - y1)
        x = x1
        y = y1

        // The x-values are increasing
        if x2 >= x1 {
            xinc1 = 1
            xinc2 = 1
        }
        // The x-values are decreasing
        else {
            xinc1 = -1
            xinc2 = -1
        }

        // The y-values are increasing
        if y2 >= y1 {
            yinc1 = 1
            yinc2 = 1
        }
        // The y-values are decreasing
        else {
            yinc1 = -1
            yinc2 = -1
        }

        if deltax >= deltay {         // There is at least one x-value for every y-value
            xinc1 = 0                  // Don't change the x when numerator >= denominator
            yinc2 = 0                  // Don't change the y for every iteration
            den = deltax
            num = deltax / 2
            add = deltay
            count = deltax				// There are more x-values than y-values
        } else {                          // There is at least one y-value for every x-value
            xinc2 = 0                  // Don't change the x for every iteration
            yinc1 = 0                  // Don't change the y when numerator >= denominator
            den = deltay
            num = deltay / 2
            add = deltax
            count = deltay         // There are more y-values than x-values
        }

        var pt = JKAShared.vec3_t()
        let bounds: [JKAShared.vec3_t] = [JKAShared.vec3_t(-1, -1, -1), JKAShared.vec3_t(1, 1, 1)]

        pt[0] = start[0]
        pt[1] = start[1]
        _ = self.GetWorldHeight(&pt, bounds, false)
        heightStart = pt[2]

        pt[0] = end[0]
        pt[1] = end[1]
        _ = self.GetWorldHeight(&pt, bounds, false)
        heightEnd = pt[2]

        heightStep = (heightEnd - heightStart) / count

        i = 0
        while i <= count {
            // Flatten the current location
            let area = CArea()

            // C converts the `int` coordinates to `float` at the stores, and the `int` radius to the `float` parameter.
            pt[0] = Float(x)
            pt[1] = Float(y)
            area.Init(pt, Float(width / 2 + (self.irand(0, width / 2))))
            // C converts the `float` height to the `int` parameter.
            // Port-note: Raven converts a NaN height to `int` when `count` is 0, because `heightStep` is then 0/0 or infinite times 0, undefined.
            // The Int32 conversion traps there, rule 19.
            self.FlattenArea(area, Int32(heightStart + (heightStep * i) - (depth / 2 - (self.irand(0, depth / 2)))), false, true, true)

            // Increase the numerator by the top of the fraction
            num += add

            if num >= den {
                // Calculate the new numerator value
                num -= den

                // Change the x and y as appropriate
                x += xinc1
                y += yinc1
            }

            // Change the x and y as appropriate
            x += xinc2
            y += yinc2
            i += 1
        }
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1245
    func CarveBezierCurve(_ numCtlPoints: Int32, _ ctlPoints: Slots<JKAShared.vec3_t>, _ steps: Int32, _ depth: Int32, _ size: Int32) {
        // Raven calls this method only from CM_CarveBezierCurve, and no file of either tree calls that function, so the method is dead.
        var i: Int32
        var choose: Int32
        var n: Int32
        var u: Float
        var t: Float
        var tt: Float
        var t1: Float
        var step: Float
        var pt = JKAShared.vec3_t()
        var lastpt = JKAShared.vec3_t()
        var b = [JKAShared.vec3_t](repeating: JKAShared.vec3_t(), count: 10)

        n = numCtlPoints - 1
        choose = 1

        i = 1
        while i <= n {
            if i == 1 {
                choose = n
            } else {
                choose = choose * (n - i + 1) / i
            }

            ctlPoints[i][0] *= choose
            ctlPoints[i][1] *= choose
            i += 1
        }

        // C converts the `int` step count to `float` by the cast.
        step = 1.0 / Float(steps)
        choose = 0
        t = step
        while t < 1 {
            b[0][0] = ctlPoints[0][0]
            b[0][1] = ctlPoints[0][1]

            u = t
            i = 1
            while i <= n {
                // Port-note: Raven writes past `b[10]` when `numCtlPoints` is 11 or more, undefined.
                // The Array index traps there, rule 19.
                b[i][0] = ctlPoints[i][0] * u
                b[i][1] = ctlPoints[i][1] * u

                u = u * t
                i += 1
            }

            pt[0] = b[n][0]
            pt[1] = b[n][1]

            t1 = 1 - t
            tt = t1

            i = n - 1
            while i >= 0 {
                pt[0] += b[i][0] * tt
                pt[1] += b[i][1] * tt

                tt = tt * t1
                i -= 1
            }

            if choose != 0 {
                self.CarveLine(lastpt, pt, depth, size)
            }

            // Save this point for next time around
            lastpt[0] = pt[0]
            lastpt[1] = pt[1]
            t += step
            choose += 1
        }
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1128
    func SaveArea(_ area: CArea?) {
        self.mAreas.append(area)
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1379
    func FractionBelowLevel(_ area: CArea?, _ height: Int32) -> Float {
        // Raven calls this method only from CM_FractionBelowLevel, and no file of either tree calls that function, so the method is dead.
        var temp = JKAShared.vec3_t()
        var icoords = [Int32](repeating: 0, count: 3)
        var count: Int32
        var level: Float

        // Work out coords in the heightmap
        temp = area!.GetPosition() - self.mBounds[0]
        // Raven's VectorInverseScaleVector macro of q_shared.h expands here, because the port has no function for an `ivec3_t`.
        // C converts each `float` quotient to the `int` slot at the store.
        icoords[0] = Int32(temp[0] / self.mTerxelSize[0])
        icoords[1] = Int32(temp[1] / self.mTerxelSize[1])
        icoords[2] = Int32(temp[2] / self.mTerxelSize[2])

        // Work out radius of area in heightmap entries
        // C converts the `float` quotient to the `int` local at the store.
        count = Int32(area!.GetRadius() / self.mTerxelSize[1])

        // AI: Raven declares `ivec3_t info` on his stack. The body uses the zeroed allocation of the storage class through the `info_FractionBelowLevel` forward.
        info_FractionBelowLevel[0] = 0
        info_FractionBelowLevel[1] = 0

        info_FractionBelowLevel[2] = height
        if height < 0 {
            info_FractionBelowLevel[2] = self.mBaseWaterHeight
        }
        CM_CircularIterate(self.mHeightMap!, self.GetRealWidth(), self.GetRealHeight(), icoords[0], icoords[1], 0, count, info_FractionBelowLevel, CM_BelowLevel)

        level = 0.0
        if info_FractionBelowLevel[1] != 0 {
            // C converts the `int` count to `float` by the cast.
            level = Float(info_FractionBelowLevel[0]) / info_FractionBelowLevel[1]
        }

        return (level)
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1488
    // AI: Raven reads `areaTypeCount` types through `int *areaTypes`. The parameter is the caller's array, the PARAMS kind `int_array`.
    func AreaCollision(_ area: CArea?, _ areaTypes: [Int32]?, _ areaTypeCount: Int32) -> Bool {
        var areas: CArea?
        var i: Int32
        var segment: Float
        var collision: Bool

        areas = self.GetFirstArea()
        while areas != nil {
            collision = false

            if area!.GetVillageID() == areas!.GetVillageID() {
                // Check for being too close angularly
                if area!.GetAngleDiff() != 0 && areas!.GetAngleDiff() != 0 {
                    segment = areas!.GetAngle() - area!.GetAngle()
                    // JKAShared's M_PI is the float of Raven's macro at q_shared.h:548, and the qualifier breaks the tie with the double of Foundation.
                    if segment < JKAShared.M_PI {
                        segment += 2 * JKAShared.M_PI
                    }
                    if segment > JKAShared.M_PI {
                        segment -= 2 * JKAShared.M_PI
                    }
                    if abs(segment) < areas!.GetAngleDiff() + area!.GetAngleDiff() {
                        collision = true
                    }
                }
            }

            // Check for buildings being too close together
            if Distance(areas!.GetPosition(), area!.GetPosition()) < areas!.GetRadius() + area!.GetRadius() {
                collision = true
            }

            if collision {
                // If no area type list was specified then all areas are fair game
                if areaTypes == nil {
                    return true
                }

                i = 0
                while i < areaTypeCount {
                    if areas!.GetType() == areaTypes![i] {
                        return (true)
                    }
                    i += 1
                }
            }
            areas = self.GetNextArea()
        }
        return (false)
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1412
    func GetFirstArea() -> CArea? {
        if self.mAreas.count == 0 {
            return (nil)
        }
        self.mAreasIt = 0
        return (self.mAreas[self.mAreasIt])
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1422
    func GetFirstObjectiveArea() -> CArea? {
        // Raven calls this method only from CM_GetFirstObjectiveArea, and no file of either tree calls that function, so the method is dead.
        if self.mAreas.count == 0 {
            return (nil)
        }
        self.mAreasIt = 0

        while self.mAreasIt != self.mAreas.count {
            // run through the areas to find the player area
            if self.mAreas[self.mAreasIt]!.GetType() == AT_OBJECTIVE {
                return (self.mAreas[self.mAreasIt])
            }
            self.mAreasIt += 1
        }
        return (nil)
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1442
    func GetPlayerArea() -> CArea? {
        // Raven calls this method only from CM_GetPlayerArea, and no file of either tree calls that function, so the method is dead.
        // do me
        if self.mAreas.count == 0 {
            return (nil)
        }
        self.mAreasIt = 0

        while self.mAreasIt != self.mAreas.count {
            // run through the areas to find the player area
            if self.mAreas[self.mAreasIt]!.GetType() == AT_PLAYER {
                return (self.mAreas[self.mAreasIt])
            }
            self.mAreasIt += 1
        }
        return (nil)
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1462
    func GetNextArea() -> CArea? {
        self.mAreasIt += 1
        if self.mAreasIt == self.mAreas.count {
            return (nil)
        }
        return (self.mAreas[self.mAreasIt])
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1472
    func GetNextObjectiveArea() -> CArea? {
        // Raven calls this method only from CM_GetNextObjectiveArea, and no file of either tree calls that function, so the method is dead.
        // Port-note: Raven increments the end iterator of `mAreas` when the last call returned NULL, undefined.
        // The Array index traps past the end there, rule 19.
        self.mAreasIt += 1

        while self.mAreasIt != self.mAreas.count {
            // run through the areas to find the player area
            if self.mAreas[self.mAreasIt]!.GetType() == AT_OBJECTIVE {
                return (self.mAreas[self.mAreasIt])
            }
            self.mAreasIt += 1
        }
        return (nil)
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
        (self.mRandomTerrain != nil)
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
        var x: Int32
        var y: Int32

        self.mCoords = Slots<JKAShared.vec3_t>(vectors: Z_Malloc(Int32(JKAShared.vec3_t.byteCount) * self.GetRealWidth() * self.GetRealHeight(), TAG_CM_TERRAIN_TEMP), count: Int(self.GetRealWidth() * self.GetRealHeight()))

        // Work out the real world coordinates of each heightmap entry
        y = 0
        while y < self.GetRealHeight() {
            x = 0
            while x < self.GetRealWidth() {
                var icoords = [Int32](repeating: 0, count: 3)
                var offset: Int32

                offset = (y * self.GetRealWidth()) + x

                // Raven's VectorSet and VectorScaleVectorAdd macros of q_shared.h expand here, because the port has no function for an `ivec3_t`.
                // C widens the unsigned byte to `int` at the store.
                icoords[0] = x
                icoords[1] = y
                icoords[2] = Int32(self.mHeightMap![offset])
                self.mCoords![offset][0] = self.GetMins()[0] + (icoords[0] * self.GetTerxelSize()[0])
                self.mCoords![offset][1] = self.GetMins()[1] + (icoords[1] * self.GetTerxelSize()[1])
                self.mCoords![offset][2] = self.GetMins()[2] + (icoords[2] * self.GetTerxelSize()[2])
                x += 1
            }
            y += 1
        }
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
    func GetRandomTerrain() -> CRandomTerrain? {
        self.mRandomTerrain
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1548
    func rand_seed(_ seed: Int32) {
        self.holdrand = UInt32(bitPattern: seed)
        // AI: Raven passes the `unsigned long` to `%d`, which reads its bits as an `int`. The argument converts by bit pattern, because the format takes no UInt32.
        Com_Printf("rand_seed = %d\n", Int32(bitPattern: self.holdrand))
    }

    /// Source: oracle/codemp/qcommon/cm_landscape.h:239
    func get_rand_seed() -> UInt32 {
        self.holdrand
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1554
    func flrand(_ min: Float, _ max: Float) -> Float {
        var result: Float

        assert((max - min) < 32768)

        self.holdrand = (self.holdrand &* 214013) &+ 2531011
        result = Float(self.holdrand >> 17)						// 0 - 32767 range
        result = ((result * (max - min)) / 32768.0) + min
        //	Com_Printf("flrand: Seed = %d\n", holdrand);

        return (result)
    }

    /// Source: oracle/codemp/qcommon/cm_terrain.cpp:1568
    func irand(_ min: Int32, _ max: Int32) -> Int32 {
        // Raven assigns his own `max` parameter. A Swift parameter is immutable, so the body takes a mutable copy of it.
        var max = max
        var result: Int32

        assert((max - min) < 32768)

        max &+= 1
        self.holdrand = (self.holdrand &* 214013) &+ 2531011
        result = Int32(bitPattern: self.holdrand >> 17)
        result = ((result &* (max &- min)) >> 15) &+ min
        //	Com_Printf("irand: Seed = %d\n", holdrand);

        return (result)
    }
}
