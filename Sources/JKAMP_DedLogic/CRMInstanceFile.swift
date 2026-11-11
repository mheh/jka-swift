import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's instance file of a random mission, the parsed `.instance` file that the mission makes its instances from.
/// Open parses the file, CreateInstance makes an instance by name, and Close frees the parse.
/// Source: oracle/codemp/RMG/RM_InstanceFile.h:11
final class CRMInstanceFile {
    let mParser = CGenericParser2()
    var mInstances: CGPGroup? = nil

    /**
    ```
    ************************************************************************************************
     * CRMInstanceFile::CRMInstanceFile
     *	constructor
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
    /// Source: oracle/codemp/RMG/RM_InstanceFile.cpp:33
    init() {
        self.mInstances = nil
    }

    /**
    ```
    ************************************************************************************************
     * CRMInstanceFile::~CRMInstanceFile
     *	Destroys the instance file by freeing the parser
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
    /// Source: oracle/codemp/RMG/RM_InstanceFile.cpp:49
    deinit {
        self.Close()
    }

    /**
    ```
    ************************************************************************************************
     * CRMInstanceFile::Open
     *	Opens the given instance file and prepares it for use in instance creation
     *
     * inputs:
     *  instance: Name of instance to open.  Note that the root path will be automatically
     *			  added and shouldnt be included in the given name
     *
     * return:
     *	true: instance file successfully loaded
     *  false: instance file could not be loaded for some reason
     *
     ************************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_InstanceFile.cpp:67
    @discardableResult
    func Open(_ instance: String) -> Bool {
        var instanceDef = CharBuf(MAX_QPATH)
        var basegroup: CGPGroup?

        // Build the filename
        Com_sprintf(&instanceDef, MAX_QPATH, "ext_data/rmg/%s.instance", instance)

        // Debug message
        Com_Printf("CM_Terrain: Loading and parsing instanceDef %s.....\n", instance)

        // Parse the text file using the generic parser
        if !Com_ParseTextFile(String(instanceDef), self.mParser) {
            Com_sprintf(&instanceDef, MAX_QPATH, "ext_data/arioche/%s.instance", instance)
            if !Com_ParseTextFile(String(instanceDef), self.mParser) {
                Com_Printf(va("CM_Terrain: Could not open instance file '%s'\n", instanceDef))
                return false
            }
        }

        // The whole file....
        basegroup = self.mParser.GetBaseParseGroup()

        // The root { } struct
        self.mInstances = basegroup!.GetSubGroups()

        // The "instances" { } structure
        // Port-note: Rule 19. Raven calls GetSubGroups through NULL when the file holds no root group, so the unwrap traps there.
        self.mInstances = self.mInstances!.GetSubGroups()

        return true
    }

    /**
    ```
    ************************************************************************************************
     * CRMInstanceFile::Close
     *	Closes an open instance file
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
    /// Source: oracle/codemp/RMG/RM_InstanceFile.cpp:114
    func Close() {
        // If not open then dont close  it
        if nil == self.mInstances {
            return
        }
        self.mParser.Clean()

        self.mInstances = nil
    }

    /**
    ```
    ************************************************************************************************
     * CRMInstanceFile::CreateInstance
     *	Creates an instance (to be freed by caller) using the given instance name.
     *
     * inputs:
     *  name: Name of the instance to read from the instance file
     *
     * return:
     *	NULL: instance could not be read from the instance file
     *  NON-NULL: instance created and returned for further use
     *
     ************************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_InstanceFile.cpp:138
    func CreateInstance(_ name: String) -> CRMInstance? {
        // AI: Raven declares a static local `instanceID` that no line reads or writes. The body drops it.

        var group: CGPGroup?
        var instance: CRMInstance

        // Make sure we were loaded
        assert(self.mInstances != nil)

        // Search through the instances for the one with the given name
        group = self.mInstances
        while group != nil {
            // Skip it if the name doesnt match
            if stricmp(name, group!.FindPairValue("name", "")!) != 0 {
                group = group!.GetNext()
                continue
            }

            // Handle the various forms of instance types
            if stricmp(group!.GetName(), "bsp") == 0 {
                instance = CRMInstance(bsp: group, self)
            } else if stricmp(group!.GetName(), "npc") == 0 {
                //			instance = new CRMNPCInstance ( group, *this );
                group = group!.GetNext()
                continue
            } else if stricmp(group!.GetName(), "group") == 0 {
                instance = CRMInstance(group: group, self)
            } else if stricmp(group!.GetName(), "random") == 0 {
                instance = CRMInstance(random: group, self)
            } else if stricmp(group!.GetName(), "void") == 0 {
                instance = CRMInstance(void: group, self)
            } else {
                group = group!.GetNext()
                continue
            }

            // If the instance isnt valid after being created then delete it
            if !instance.IsValid() {
                // AI: Raven deletes the instance. The return releases it.
                return nil
            }

            // The instance was successfully created so return it
            return instance
        }

        // The instance wasnt found in the file so report it
        Com_Printf(va("WARNING:  Instance '%s' was not found in the active instance file\n", name))

        return nil
    }
}
