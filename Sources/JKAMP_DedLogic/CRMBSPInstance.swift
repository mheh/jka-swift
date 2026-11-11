import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// The fields that Raven's bsp instance adds to `CRMInstance`, the payload of its `bsp` kind.
/// The extension below holds the constructor and the overrides, each with Raven's qualified name.
/// Source: oracle/codemp/RMG/RM_Instance_BSP.h:9
struct CRMBSPInstance {
    var mBsp = CharBuf(MAX_QPATH)
    var mAngleVariance: Float = 0
    var mBaseAngle: Float = 0
    var mAngleDiff: Float = 0

    var mHoleRadius: Float = 0

    /// Source: oracle/codemp/RMG/RM_Instance_BSP.h:26
    func GetHoleRadius() -> Float {
        self.mHoleRadius
    }

    /// Source: oracle/codemp/RMG/RM_Instance_BSP.h:30
    func GetModelName() -> String {
        String(self.mBsp)
    }

    /// Source: oracle/codemp/RMG/RM_Instance_BSP.h:31
    func GetAngleDiff() -> Float {
        (self.mAngleDiff)
    }

    /// Source: oracle/codemp/RMG/RM_Instance_BSP.h:32
    func GetAngularType() -> Bool {
        (self.mAngleDiff != 0.0)
    }
}

// MARK: - CRMBSPInstance

extension CRMInstance {
    /**
    ```
    ************************************************************************************************
     * CRMBSPInstance::CRMBSPInstance
     *	constructs a building instance object using the given parser group
     *
     * inputs:
     *  instance:  parser group containing information about the building instance
     *
     * return:
     *	none
     *
     ************************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_Instance_BSP.cpp:31
    convenience init(bsp instGroup: CGPGroup?, _ instFile: CRMInstanceFile) {
        self.init(instGroup, instFile, .bsp(CRMBSPInstance()))

        // AI: Raven writes the fields of the subclass in place. The body writes them into the payload and stores it in `kind` at the end.
        var bsp = CRMBSPInstance()

        strcpy(&bsp.mBsp, instGroup!.FindPairValue("file", "")!)

        // Raven's DEG2RAD macro of q_shared.h expands at each site, because C computes it in double for the double that atof returns.
        bsp.mAngleVariance = Float((atof(instGroup!.FindPairValue("anglevariance", "0")!) * Double(JKAShared.M_PI)) / 180.0)
        bsp.mBaseAngle = Float((atof(instGroup!.FindPairValue("baseangle", "0")!) * Double(JKAShared.M_PI)) / 180.0)
        bsp.mAngleDiff = Float((atof(instGroup!.FindPairValue("anglediff", "0")!) * Double(JKAShared.M_PI)) / 180.0)
        self.mSpacingRadius = Float(atof(instGroup!.FindPairValue("spacing", "100")!))
        self.mSpacingLine = atoi(instGroup!.FindPairValue("spacingline", "0")!)
        self.mSurfaceSprites = (Q_stricmp(instGroup!.FindPairValue("surfacesprites", "no")!, "yes") == 0) ? true : false
        self.mLockOrigin = (Q_stricmp(instGroup!.FindPairValue("lockorigin", "no")!, "yes") == 0) ? true : false
        self.mFlattenRadius = Float(atof(instGroup!.FindPairValue("flatten", "0")!))
        bsp.mHoleRadius = Float(atof(instGroup!.FindPairValue("hole", "0")!))

        let automapSymName = instGroup!.FindPairValue("automap_symbol", "building")!
        if 0 == Q_stricmp(automapSymName, "none") {
            self.mAutomapSymbol = AUTOMAP_NONE
        } else if 0 == Q_stricmp(automapSymName, "building") {
            self.mAutomapSymbol = AUTOMAP_BLD
        } else if 0 == Q_stricmp(automapSymName, "objective") {
            self.mAutomapSymbol = AUTOMAP_OBJ
        } else if 0 == Q_stricmp(automapSymName, "start") {
            self.mAutomapSymbol = AUTOMAP_START
        } else if 0 == Q_stricmp(automapSymName, "end") {
            self.mAutomapSymbol = AUTOMAP_END
        } else if 0 == Q_stricmp(automapSymName, "enemy") {
            self.mAutomapSymbol = AUTOMAP_ENEMY
        } else if 0 == Q_stricmp(automapSymName, "friend") {
            self.mAutomapSymbol = AUTOMAP_FRIEND
        } else if 0 == Q_stricmp(automapSymName, "wall") {
            self.mAutomapSymbol = AUTOMAP_WALL
        } else {
            self.mAutomapSymbol = atoi(automapSymName)
        }

        // optional instance objective strings
        self.SetMessage(instGroup!.FindPairValue("objective_message", "")!)
        self.SetDescription(instGroup!.FindPairValue("objective_description", "")!)
        self.SetInfo(instGroup!.FindPairValue("objective_info", "")!)

        self.mBounds[0][0] = 0
        self.mBounds[0][1] = 0
        self.mBounds[1][0] = 0
        self.mBounds[1][1] = 0

        // C converts the `float` variance to the `int` parameter of irand.
        // Port-note: Raven converts a NaN or an out-of-range float to `int` here, undefined.
        // The Int32 conversion traps there, rule 19.
        bsp.mBaseAngle += (TheRandomMissionManager!.GetLandScape()!.irand(0, Int32(bsp.mAngleVariance)) - bsp.mAngleVariance / 2)

        self.kind = .bsp(bsp)
    }

    /// Raven's `CRMBSPInstance::GetPreviewColor`.
    /// Source: oracle/codemp/RMG/RM_Instance_BSP.h:24
    func CRMBSPInstance_GetPreviewColor() -> Int32 {
        (255 << 24) + 255
    }

    /**
    ```
    ************************************************************************************************
     * CRMBSPInstance::Spawn
     *	spawns a bsp into the world using the previously aquired origin
     *
     * inputs:
     *  none
     *
     * return:
     *	none
     *
     ************************************************************************************************
    ```
    */
    /// Raven's `CRMBSPInstance::Spawn`, with the payload of the `bsp` kind as its first parameter.
    /// Source: oracle/codemp/RMG/RM_Instance_BSP.cpp:80
    func CRMBSPInstance_Spawn(_ bsp: CRMBSPInstance, _ terrain: CRandomTerrain?, _ IsServer: Bool) -> Bool {
        //	TEntity*	ent;
        var yaw: Float
        var temp = CharBuf(10000)
        var savePtr: String?
        var origin = JKAShared.vec3_t()
        var notmirrored = JKAShared.vec3_t()
        let water_level = terrain!.GetLandScape()!.GetWaterHeight()

        let terxelSize = terrain!.GetLandScape()!.GetTerxelSize()
        let bounds = terrain!.GetLandScape()!.GetBounds()

        // If this entity somehow lost its collision flag then boot it
        if !self.GetArea().IsCollisionEnabled() {
            return false
        }

        // copy out the unmirrored version
        _VectorCopy(self.GetOrigin(), &notmirrored)

        // we want to mirror it before determining the Z value just in case the landscape isn't perfectly mirrored
        if self.mMirror != 0 {
            self.mArea!.mOrigin[0] = TheRandomMissionManager!.GetLandScape()!.GetBounds()[0][0] + TheRandomMissionManager!.GetLandScape()!.GetBounds()[1][0] - self.GetOrigin()[0]
            self.mArea!.mOrigin[1] = TheRandomMissionManager!.GetLandScape()!.GetBounds()[0][1] + TheRandomMissionManager!.GetLandScape()!.GetBounds()[1][1] - self.GetOrigin()[1]
        }

        // Align the instance to the center of a terxel
        // Port-note: Raven converts a NaN or an out-of-range float to `int` here, undefined.
        // The Int32 conversion traps there, rule 19.
        self.mArea!.mOrigin[0] = bounds[0][0] + Int32((self.GetOrigin()[0] - bounds[0][0] + terxelSize[0] / 2) / terxelSize[0]) * terxelSize[0]
        self.mArea!.mOrigin[1] = bounds[0][1] + Int32((self.GetOrigin()[1] - bounds[0][1] + terxelSize[1] / 2) / terxelSize[1]) * terxelSize[1]

        // Make sure the bsp is resting on the ground, not below or above it
        // NOTE: This check is basically saying "is this instance not a bridge", because when instances are created they are all
        // placed above the world's Z boundary, EXCEPT FOR BRIDGES. So this call to GetWorldHeight will move all other instances down to
        // ground level except bridges
        if self.GetOrigin()[2] > terrain!.GetBounds()[1][2] {
            if self.GetFlattenRadius() != 0 {
                _ = terrain!.GetLandScape()!.GetWorldHeight(&self.mArea!.mOrigin, self.GetBounds(), false)
                self.mArea!.mOrigin[2] += 5
            } else if IsServer {
                // if this instance does not flatten the ground around it, do a trace to more accurately determine its Z value
                // Raven's record lives to the end of his block, so the block is the closure.
                // The closure returns true where Raven's block returns false from the function.
                let failed = Trace.scratch { tr -> Bool in
                    var end = JKAShared.vec3_t()
                    var start = JKAShared.vec3_t()

                    _VectorCopy(self.GetOrigin(), &end)
                    _VectorCopy(self.GetOrigin(), &start)
                    // start the trace below the top height of the landscape
                    start[2] = TheRandomMissionManager!.GetLandScape()!.GetBounds()[1][2] - 1
                    // end the trace at the bottom of the world
                    end[2] = Float(MIN_WORLD_COORD)

                    tr.clear()
                    // C reads Raven's qfalse as the int 0 of the capsule parameter.
                    SV_Trace(tr, start, vec3_origin, vec3_origin, end, -1, CONTENTS_TERRAIN | CONTENTS_SOLID, 0, 0, 10)

                    if (tr.contents & CONTENTS_TERRAIN) == 0 || (tr.fraction == 1.0) {
                        if false {
                            assert(false) // this should never happen
                        }

                        // restore the unmirrored origin
                        _VectorCopy(notmirrored, &self.mArea!.mOrigin)
                        // don't spawn
                        return true
                    }
                    // assign the Z-value to wherever it hit the terrain
                    self.mArea!.mOrigin[2] = tr.endpos[2]
                    // lower it a little, otherwise the bottom of the instance might be exposed if on some weird sloped terrain
                    self.mArea!.mOrigin[2] -= 16 // FIXME: would it be better to use a number related to the instance itself like 1/5 it's height or something...
                    return false
                }
                if failed {
                    return false
                }
            }

        } else {
            _ = terrain!.GetLandScape()!.GetWorldHeight(&self.mArea!.mOrigin, self.GetBounds(), true)
        }

        // save away the origin
        _VectorCopy(self.GetOrigin(), &origin)
        // make sure not to spawn if in water
        if !self.HasObjective() && self.GetOrigin()[2] < water_level {
            return false
        }
        // restore the origin
        _VectorCopy(origin, &self.mArea!.mOrigin)

        if self.mMirror != 0 {
            // change blue things to red for symmetric maps
            if strlen(self.mFilter) > 0 {
                let blue = strstr(self.mFilter, "blue")
                if let blue {
                    self.mFilter[blue] = CChar(0)
                    strcat(&self.mFilter, "red")
                    self.SetSide(SIDE_RED)
                }
            }
            if strlen(self.mTeamFilter) > 0 {
                let blue = strstr(self.mTeamFilter, "blue")
                if blue != nil {
                    strcpy(&self.mTeamFilter, "red")
                    self.SetSide(SIDE_RED)
                }
            }
            yaw = RAD2DEG(self.mArea!.GetAngle() + bsp.mBaseAngle) + 180
        } else {
            yaw = RAD2DEG(self.mArea!.GetAngle() + bsp.mBaseAngle)
        }

        /*
        	if( TheRandomMissionManager->GetMission()->GetSymmetric() )
        	{
        		vec3_t	diagonal;
        		vec3_t	lineToPoint;
        		vec3_t	mins;
        		vec3_t	maxs;
        		vec3_t	point;
        		vec3_t	vProj;
        		vec3_t	vec;
        		float	distance;

        		VectorCopy( TheRandomMissionManager->GetLandScape()->GetBounds()[1], maxs );
        		VectorCopy( TheRandomMissionManager->GetLandScape()->GetBounds()[0], mins );
        		VectorCopy( GetOrigin(), point );
        		mins[2] = maxs[2] = point[2] = 0;
        		VectorSubtract( point, mins, lineToPoint );
        		VectorSubtract( maxs, mins, diagonal);


        		VectorNormalize(diagonal);
        		VectorMA( mins, DotProduct(lineToPoint, diagonal), diagonal, vProj);
        		VectorSubtract(point, vProj, vec );
        		distance = VectorLength(vec);

        		// if an instance is too close to the imaginary diagonal that cuts the world in half, don't spawn it
        		// otherwise you can get overlapping instances
        		if( distance < GetSpacingRadius() )
        		{
        #ifdef _DEBUG
        			mAutomapSymbol = AUTOMAP_END;
        #endif
        			if( !HasObjective() )
        			{
        				return false;
        			}
        		}
        	}
        */

        // Spawn in the bsp model
        // Port-note: Raven converts a NaN or an out-of-range radius to `int` at the two `(int)` arguments, undefined.
        // The Int32 conversion traps there, rule 19.
        // AI: Raven calls sprintf with no size. The body calls Com_sprintf with the size of temp.
        Com_sprintf(
            &temp,
            10000,
            "{\n"
            + "\"classname\"   \"misc_bsp\"\n"
            + "\"bspmodel\"    \"%s\"\n"
            + "\"origin\"      \"%f %f %f\"\n"
            + "\"angles\"      \"0 %f 0\"\n"
            + "\"filter\"      \"%s\"\n"
            + "\"teamfilter\"  \"%s\"\n"
            + "\"spacing\"\t \"%d\"\n"
            + "\"flatten\"\t \"%d\"\n"
            + "}\n",
            bsp.mBsp,
            self.GetOrigin()[0],
            self.GetOrigin()[1],
            self.GetOrigin()[2],
            AngleNormalize360(yaw),
            self.mFilter,
            self.mTeamFilter,
            Int32(self.GetSpacingRadius()),
            Int32(self.GetFlattenRadius())
        )

        if IsServer {
            // only allow for true spawning on the server
            savePtr = sv.entityParsePoint
            sv.entityParsePoint = String(temp)
            VM_Call(gvm!, GAME_SPAWN_RMG_ENTITY)
            // AI: Raven restores the saved pointer. The setter interns the saved text, so the parse goes on over a copy of the same text.
            sv.entityParsePoint = savePtr
        }

        self.DrawAutomapSymbol()

        Com_DPrintf(
            "RMG:  Building '%s' spawned at (%f %f %f)\n",
            bsp.mBsp,
            self.GetOrigin()[0],
            self.GetOrigin()[1],
            self.GetOrigin()[2]
        )
        // now restore the instances un-mirrored origin
        // NOTE: all this origin flipping, setting the side etc... should be done when mMirror is set
        // because right after this function is called, mMirror is set to 0 but all the instance data is STILL MIRRORED -- not good
        _VectorCopy(notmirrored, &self.mArea!.mOrigin)

        return true
    }
}
