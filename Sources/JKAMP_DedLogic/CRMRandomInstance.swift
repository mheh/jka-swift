import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/RMG/RM_Instance_Random.h:9
let MAX_RANDOM_INSTANCES = 64 as Int32

/// The field that Raven's random instance adds to `CRMInstance`, the payload of its `random` kind.
/// The extension below holds the constructor and the overrides, each with Raven's qualified name.
/// Source: oracle/codemp/RMG/RM_Instance_Random.h:11
struct CRMRandomInstance {
    var mInstance: CRMInstance? = nil
}

// MARK: - CRMRandomInstance

extension CRMInstance {
    /**
    ```
    ************************************************************************************************
     * CRMRandomInstance::CRMRandomInstance
     *	constructs a random instance by choosing one of the sub instances and creating it
     *
     * inputs:
     *  instGroup:  parser group containing infromation about this instance
     *  instFile:   reference to an open instance file for creating sub instances
     *
     * return:
     *	none
     *
     ************************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_Instance_Random.cpp:29
    convenience init(random instGroup: CGPGroup?, _ instFile: CRMInstanceFile) {
        self.init(instGroup, instFile, .random(CRMRandomInstance()))

        // AI: Raven writes the field of the subclass in place. The body writes it into the payload and stores it in `kind` at the end.
        var random = CRMRandomInstance()
        var instGroup = instGroup

        var group: CGPGroup?
        var groups = [CGPGroup?](repeating: nil, count: Int(MAX_RANDOM_INSTANCES))
        var numGroups: Int32

        // Build a list of the groups one can be chosen
        numGroups = 0
        group = instGroup!.GetSubGroups()
        while group != nil {
            // If this isnt an instance group then skip it
            if stricmp(group!.GetName(), "instance") != 0 {
                group = group!.GetNext()
                continue
            }

            var multiplier = atoi(group!.FindPairValue("multiplier", "1")!)
            while multiplier > 0 && numGroups < MAX_RANDOM_INSTANCES {
                groups[numGroups] = group
                numGroups += 1
                multiplier -= 1
            }
            group = group!.GetNext()
        }

        // No groups, no instance
        if numGroups == 0 {
            // Initialize this now
            random.mInstance = nil

            // Port-note: Rule 19. The loop above ends only when `group` is NULL, so Raven calls FindPairValue through NULL here.
            // The unwrap traps there.
            Com_Printf("WARNING: No sub instances specified for random instance '%s'\n", group!.FindPairValue("name", "unknown")!)
            self.kind = .random(random)
            return
        }

        // Now choose a group to parse
        instGroup = groups[TheRandomMissionManager!.GetLandScape()!.irand(0, numGroups - 1)]

        // Create the child instance now.  If the instance create fails then the
        // IsValid routine will return false and this instance wont be added
        random.mInstance = instFile.CreateInstance(instGroup!.FindPairValue("name", "")!)
        // Port-note: Rule 19. Raven calls SetFilter through NULL when CreateInstance fails, so the unwrap traps there before IsValid can run.
        random.mInstance!.SetFilter(String(self.mFilter))
        random.mInstance!.SetTeamFilter(String(self.mTeamFilter))

        self.mAutomapSymbol = random.mInstance!.GetAutomapSymbol()

        self.SetMessage(random.mInstance!.GetMessage())
        self.SetDescription(random.mInstance!.GetDescription())
        self.SetInfo(random.mInstance!.GetInfo())

        self.kind = .random(random)
    }

    /**
    ```
    ************************************************************************************************
     * CRMRandomInstance::~CRMRandomInstance
     *	Deletes the sub instance
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
    /// Raven's `CRMRandomInstance::~CRMRandomInstance`, the arm of the `random` kind in the deinit of `CRMInstance`.
    /// Source: oracle/codemp/RMG/RM_Instance_Random.cpp:91
    func CRMRandomInstance_deinit() {
        guard case .random(var random) = self.kind else { return }

        if random.mInstance != nil {
            // AI: Raven deletes the sub instance. The store of nil releases the class, and its deinit runs Raven's destructor.
            random.mInstance = nil
        }

        self.kind = .random(random)
    }

    /// Raven's `CRMRandomInstance::SetMirror`.
    /// Source: oracle/codemp/RMG/RM_Instance_Random.cpp:99
    func CRMRandomInstance_SetMirror(_ random: CRMRandomInstance, _ mirror: Int32) {
        self.CRMInstance_SetMirror(mirror)
        if random.mInstance != nil {
            random.mInstance!.SetMirror(mirror)
        }
    }

    /// Raven's `CRMRandomInstance::SetFilter`.
    /// Source: oracle/codemp/RMG/RM_Instance_Random.cpp:108
    func CRMRandomInstance_SetFilter(_ random: CRMRandomInstance, _ filter: String) {
        self.CRMInstance_SetFilter(filter)
        if random.mInstance != nil {
            random.mInstance!.SetFilter(filter)
        }
    }

    /// Raven's `CRMRandomInstance::SetTeamFilter`.
    /// Source: oracle/codemp/RMG/RM_Instance_Random.cpp:117
    func CRMRandomInstance_SetTeamFilter(_ random: CRMRandomInstance, _ teamFilter: String) {
        self.CRMInstance_SetTeamFilter(teamFilter)
        if random.mInstance != nil {
            random.mInstance!.SetTeamFilter(teamFilter)
        }
    }

    /**
    ```
    ************************************************************************************************
     * CRMRandomInstance::PreSpawn
     *	Prepares for the spawn of the random instance
     *
     * inputs:
     *  landscape: landscape object this instance will be spawned on
     *
     * return:
     *	true: preparation successful
     *  false: preparation failed
     *
     ************************************************************************************************
    ```
    */
    /// Raven's `CRMRandomInstance::PreSpawn`.
    /// Source: oracle/codemp/RMG/RM_Instance_Random.cpp:138
    func CRMRandomInstance_PreSpawn(_ random: CRMRandomInstance, _ terrain: CRandomTerrain?, _ IsServer: Bool) -> Bool {
        assert(random.mInstance != nil)

        random.mInstance!.SetFlattenHeight(self.GetFlattenHeight())

        return random.mInstance!.PreSpawn(terrain, IsServer)
    }

    /**
    ```
    ************************************************************************************************
     * CRMRandomInstance::Spawn
     *	Spawns the instance onto the landscape
     *
     * inputs:
     *  landscape: landscape object this instance will be spawned on
     *
     * return:
     *	true: spawn successful
     *  false: spawn failed
     *
     ************************************************************************************************
    ```
    */
    /// Raven's `CRMRandomInstance::Spawn`.
    /// Source: oracle/codemp/RMG/RM_Instance_Random.cpp:159
    func CRMRandomInstance_Spawn(_ random: CRMRandomInstance, _ terrain: CRandomTerrain?, _ IsServer: Bool) -> Bool {
        random.mInstance!.SetObjective(self.GetObjective())
        random.mInstance!.SetSide(self.GetSide())

        if !random.mInstance!.Spawn(terrain, IsServer) {
            return false
        }

        return true
    }

    /**
    ```
    ************************************************************************************************
     * CRMRandomInstance::SetArea
     *	Forwards the given area off to the internal instance
     *
     * inputs:
     *  area: area to be set
     *
     * return:
     *	none
     *
     ************************************************************************************************
    ```
    */
    /// Raven's `CRMRandomInstance::SetArea`.
    /// Source: oracle/codemp/RMG/RM_Instance_Random.cpp:183
    func CRMRandomInstance_SetArea(_ random: CRMRandomInstance, _ amanager: CRMAreaManager?, _ area: CRMArea?) {
        self.CRMInstance_SetArea(amanager, area)

        random.mInstance!.SetArea(amanager, self.mArea)
    }

    /// Raven's `CRMRandomInstance::IsValid`.
    /// Source: oracle/codemp/RMG/RM_Instance_Random.h:22
    func CRMRandomInstance_IsValid(_ random: CRMRandomInstance) -> Bool {
        random.mInstance == nil ? false : true
    }

    /// Raven's `CRMRandomInstance::GetPreviewColor`.
    /// Source: oracle/codemp/RMG/RM_Instance_Random.h:24
    func CRMRandomInstance_GetPreviewColor(_ random: CRMRandomInstance) -> Int32 {
        random.mInstance!.GetPreviewColor()
    }

    /// Raven's `CRMRandomInstance::GetSpacingRadius`.
    /// Source: oracle/codemp/RMG/RM_Instance_Random.h:26
    func CRMRandomInstance_GetSpacingRadius(_ random: CRMRandomInstance) -> Float {
        random.mInstance!.GetSpacingRadius()
    }

    /// Raven's `CRMRandomInstance::GetSpacingLine`.
    /// Source: oracle/codemp/RMG/RM_Instance_Random.h:27
    func CRMRandomInstance_GetSpacingLine(_ random: CRMRandomInstance) -> Int32 {
        random.mInstance!.GetSpacingLine()
    }

    /// Raven's `CRMRandomInstance::GetFlattenRadius`.
    /// Source: oracle/codemp/RMG/RM_Instance_Random.h:28
    func CRMRandomInstance_GetFlattenRadius(_ random: CRMRandomInstance) -> Float {
        random.mInstance!.GetFlattenRadius()
    }

    /// Raven's `CRMRandomInstance::GetLockOrigin`.
    /// Source: oracle/codemp/RMG/RM_Instance_Random.h:29
    func CRMRandomInstance_GetLockOrigin(_ random: CRMRandomInstance) -> Bool {
        random.mInstance!.GetLockOrigin()
    }
}
