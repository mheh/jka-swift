import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// The fields that Raven's group instance adds to `CRMInstance`, the payload of its `group` kind.
/// The extension below holds the constructor and the overrides, each with Raven's qualified name.
/// Source: oracle/codemp/RMG/RM_Instance_Group.h:9
struct CRMGroupInstance {
    var mInstances: rmInstanceList_t = []
    var mConfineRadius: Float = 0
    var mPaddingSize: Float = 0
}

// MARK: - CRMGroupInstance

extension CRMInstance {
    /**
    ```
    ************************************************************************************************
     * CRMGroupInstance::CRMGroupInstance
     *	constructur
     *
     * inputs:
     *  settlementID:  ID of the settlement being created
     *
     * return:
     *	none
     *
     ************************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_Instance_Group.cpp:28
    convenience init(group instGroup: CGPGroup?, _ instFile: CRMInstanceFile) {
        self.init(instGroup, instFile, .group(CRMGroupInstance()))

        // AI: Raven writes the fields of the subclass in place. The body writes them into the payload and stores it in `kind` at the end.
        var group = CRMGroupInstance()
        var instGroup = instGroup

        // Grab the padding and confine radius
        group.mPaddingSize = Float(atof(instGroup!.FindPairValue("padding", va("%i", TheRandomMissionManager!.GetMission()!.GetDefaultPadding()))!))
        group.mConfineRadius = Float(atof(instGroup!.FindPairValue("confine", "0")!))

        let automapSymName = instGroup!.FindPairValue("automap_symbol", "none")!
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
        } else {
            self.mAutomapSymbol = atoi(automapSymName)
        }

        // optional instance objective strings
        self.SetMessage(instGroup!.FindPairValue("objective_message", "")!)
        self.SetDescription(instGroup!.FindPairValue("objective_description", "")!)
        self.SetInfo(instGroup!.FindPairValue("objective_info", "")!)

        // Iterate through the sub groups to determine the instances which make up the group
        instGroup = instGroup!.GetSubGroups()

        while instGroup != nil {
            var instance: CRMInstance?
            let name: String
            let mincount: Int32
            let maxcount: Int32
            var count: Int32

            // Make sure only instances are specified as sub groups
            assert(0 == stricmp(instGroup!.GetName(), "instance"))

            // Grab the name
            name = instGroup!.FindPairValue("name", "")!

            // Grab the range information
            // AI: Raven reads `minrange` and `maxrange` into locals that no line reads. The locals drop.

            // Grab the count information and randomly generate a count value
            mincount = atoi(instGroup!.FindPairValue("mincount", "1")!)
            maxcount = atoi(instGroup!.FindPairValue("maxcount", "1")!)
            count = mincount

            if maxcount > mincount {
                count += (TheRandomMissionManager!.GetLandScape()!.irand(0, maxcount - mincount))
            }

            // For each count create and add the instance
            // Port-note: With `mincount` below 0 and `maxcount` not above it, Raven decrements `count` through INT_MIN, undefined.
            // The Swift decrement traps there, rule 19.
            while count != 0 {
                defer { count -= 1 }

                // Create the instance
                instance = instFile.CreateInstance(name)

                // Skip this instance if it couldnt be created for some reason.  The CreateInstance
                // method will report an error so no need to do so here.
                if nil == instance {
                    continue
                }

                // Set the min and max range for the instance
                instance!.SetFilter(String(self.mFilter))
                instance!.SetTeamFilter(String(self.mTeamFilter))

                // Add the instance to the list
                group.mInstances.append(instance!)
            }

            // Next sub group
            instGroup = instGroup!.GetNext()
        }

        self.kind = .group(group)
    }

    /**
    ```
    ************************************************************************************************
     * CRMGroupInstance::~CRMGroupInstance
     *	Removes all buildings and inhabitants
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
    /// Raven's `CRMGroupInstance::~CRMGroupInstance`, the arm of the `group` kind in the deinit of `CRMInstance`.
    /// Source: oracle/codemp/RMG/RM_Instance_Group.cpp:120
    func CRMGroupInstance_deinit() {
        // Cleanup
        self.CRMGroupInstance_RemoveInstances()
    }

    /**
    ```
    ************************************************************************************************
     * CRMGroupInstance::SetFilter
     *	Sets a filter used to exclude instances
     *
     * inputs:
     *  filter: filter name
     *
     * return:
     *	none
     *
     ************************************************************************************************
    ```
    */
    /// Raven's `CRMGroupInstance::SetFilter`.
    /// Source: oracle/codemp/RMG/RM_Instance_Group.cpp:137
    func CRMGroupInstance_SetFilter(_ group: CRMGroupInstance, _ filter: String) {
        self.CRMInstance_SetFilter(filter)
        for it in group.mInstances {
            it.SetFilter(filter)
        }
    }

    /**
    ```
    ************************************************************************************************
     * CRMGroupInstance::SetTeamFilter
     *	Sets the filter used to exclude team based instances
     *
     * inputs:
     *  teamFilter: filter name
     *
     * return:
     *	none
     *
     ************************************************************************************************
    ```
    */
    /// Raven's `CRMGroupInstance::SetTeamFilter`.
    /// Source: oracle/codemp/RMG/RM_Instance_Group.cpp:159
    func CRMGroupInstance_SetTeamFilter(_ group: CRMGroupInstance, _ teamFilter: String) {
        self.CRMInstance_SetTeamFilter(teamFilter)
        for it in group.mInstances {
            it.SetTeamFilter(teamFilter)
        }
    }

    /**
    ```
    ************************************************************************************************
     * CRMGroupInstance::SetMirror
     *	Sets the flag to mirror an instance on map
     *
     * inputs:
     *  mirror
     *
     * return:
     *	none
     *
     ************************************************************************************************
    ```
    */
    /// Raven's `CRMGroupInstance::SetMirror`.
    /// Source: oracle/codemp/RMG/RM_Instance_Group.cpp:181
    func CRMGroupInstance_SetMirror(_ group: CRMGroupInstance, _ mirror: Int32) {
        self.CRMInstance_SetMirror(mirror)
        for it in group.mInstances {
            it.SetMirror(mirror)
        }
    }

    /**
    ```
    ************************************************************************************************
     * CRMGroupInstance::RemoveInstances
     *	Removes all instances associated with the group
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
    /// Raven's `CRMGroupInstance::RemoveInstances`, a protected method that only the destructor calls.
    /// Source: oracle/codemp/RMG/RM_Instance_Group.cpp:204
    func CRMGroupInstance_RemoveInstances() {
        guard case .group(var group) = self.kind else { return }

        // AI: Raven deletes each instance of the list and then clears it. The clear of the Array releases each instance, and its deinit runs Raven's destructor.
        group.mInstances.removeAll()

        self.kind = .group(group)
    }

    /**
    ```
    ************************************************************************************************
     * CRMGroupInstance::PreSpawn
     *	Prepares the group for spawning by
     *
     * inputs:
     *  landscape: landscape to calculate the position within
     *  instance: instance to calculate the position for
     *
     * return:
     *	none
     *
     ************************************************************************************************
    ```
    */
    /// Raven's `CRMGroupInstance::PreSpawn`.
    /// Source: oracle/codemp/RMG/RM_Instance_Group.cpp:228
    func CRMGroupInstance_PreSpawn(_ group: CRMGroupInstance, _ terrain: CRandomTerrain?, _ IsServer: Bool) -> Bool {
        for instance in group.mInstances {
            instance.SetFlattenHeight(self.mFlattenHeight)

            // Add the instance to the landscape now
            instance.PreSpawn(terrain, IsServer)
        }

        return self.CRMInstance_PreSpawn(terrain, IsServer)
    }

    /**
    ```
    ************************************************************************************************
     * CRMGroupInstance::Spawn
     *	Adds the group instance to the given landscape using the specified origin.  All sub instances
     *  will be added to the landscape within their min and max range from the origin.
     *
     * inputs:
     *  landscape: landscape to add the instance group to
     *  origin: origin of the instance group
     *
     * return:
     *	none
     *
     ************************************************************************************************
    ```
    */
    /// Raven's `CRMGroupInstance::Spawn`.
    /// Source: oracle/codemp/RMG/RM_Instance_Group.cpp:258
    func CRMGroupInstance_Spawn(_ group: CRMGroupInstance, _ terrain: CRandomTerrain?, _ IsServer: Bool) -> Bool {
        // Spawn all the instances associated with this group
        for instance in group.mInstances {
            instance.SetSide(self.GetSide()) // which side owns it?

            // Add the instance to the landscape now
            instance.Spawn(terrain, IsServer)
        }

        self.DrawAutomapSymbol()

        return true
    }

    /**
    ```
    ************************************************************************************************
     * CRMGroupInstance::Preview
     *	Renders debug information for the instance
     *
     * inputs:
     *  from: point to render the preview from
     *
     * return:
     *	none
     *
     ************************************************************************************************
    ```
    */
    /// Raven's `CRMGroupInstance::Preview`.
    /// Source: oracle/codemp/RMG/RM_Instance_Group.cpp:288
    func CRMGroupInstance_Preview(_ group: CRMGroupInstance, _ from: JKAShared.vec3_t) {
        self.CRMInstance_Preview(from)

        // Render all the instances
        for instance in group.mInstances {
            instance.Preview(from)
        }
    }

    /**
    ```
    ************************************************************************************************
     * CRMGroupInstance::SetArea
     *	Overidden to make sure the groups area doesnt eat up any room.  The collision on the
     *  groups area will be turned off
     *
     * inputs:
     *  area: area to set
     *
     * return:
     *	none
     *
     ************************************************************************************************
    ```
    */
    /// Raven's `CRMGroupInstance::SetArea`.
    /// Source: oracle/codemp/RMG/RM_Instance_Group.cpp:315
    func CRMGroupInstance_SetArea(_ group: CRMGroupInstance, _ amanager: CRMAreaManager?, _ area: CRMArea?) {
        let collide = area!.IsCollisionEnabled()

        // Disable collision
        area!.EnableCollision(false)

        // Do what really needs to get done
        self.CRMInstance_SetArea(amanager, area)

        // Prepare for spawn by calculating all the positions of the sub instances
        // and flattening the ground below them.
        for instance in group.mInstances {
            var newarea: CRMArea?
            var origin = JKAShared.vec3_t()

            // Drop it in the center of the group for now
            origin[0] = self.GetOrigin()[0]
            origin[1] = self.GetOrigin()[1]
            origin[2] = 2500

            // Set the area of position
            newarea = amanager!.CreateArea(&origin, instance.GetSpacingRadius(), instance.GetSpacingLine(), group.mPaddingSize, group.mConfineRadius, self.GetOrigin(), self.GetOrigin(), instance.GetFlattenRadius() != 0 ? true : false, collide, instance.GetLockOrigin(), area!.GetSymmetric())
            instance.SetArea(amanager, newarea)
        }
    }

    /// Raven's `CRMGroupInstance::GetPreviewColor`.
    /// Source: oracle/codemp/RMG/RM_Instance_Group.h:31
    func CRMGroupInstance_GetPreviewColor() -> Int32 {
        (255 << 24) + (255 << 8)
    }

    /// Raven's `CRMGroupInstance::GetSpacingRadius`.
    /// Source: oracle/codemp/RMG/RM_Instance_Group.h:32
    func CRMGroupInstance_GetSpacingRadius() -> Float {
        0
    }

    /// Raven's `CRMGroupInstance::GetFlattenRadius`.
    /// Source: oracle/codemp/RMG/RM_Instance_Group.h:33
    func CRMGroupInstance_GetFlattenRadius() -> Float {
        0
    }
}
