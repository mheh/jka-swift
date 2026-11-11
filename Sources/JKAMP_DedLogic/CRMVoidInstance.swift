import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

// MARK: - CRMVoidInstance

/// Raven's void instance adds no field, so its `void` kind carries no payload.
/// Source: oracle/codemp/RMG/RM_Instance_Void.h:9
extension CRMInstance {
    /**
    ```
    ************************************************************************************************
     * CRMVoidInstance::CRMVoidInstance
     *	constructs a void instance
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
    /// Source: oracle/codemp/RMG/RM_Instance_Void.cpp:29
    convenience init(void instGroup: CGPGroup?, _ instFile: CRMInstanceFile) {
        self.init(instGroup, instFile, .void)

        self.mSpacingRadius = Float(atof(instGroup!.FindPairValue("spacing", "0")!))
        self.mFlattenRadius = Float(atof(instGroup!.FindPairValue("flatten", "0")!))
    }

    /**
    ```
    ************************************************************************************************
     * CRMVoidInstance::SetArea
     *	Overidden to make sure the void area doesnt continually.
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
    /// Raven's `CRMVoidInstance::SetArea`.
    /// Source: oracle/codemp/RMG/RM_Instance_Void.cpp:47
    func CRMVoidInstance_SetArea(_ amanager: CRMAreaManager?, _ area: CRMArea?) {
        // Disable collision
        area!.EnableCollision(false)

        // Do what really needs to get done
        self.CRMInstance_SetArea(amanager, area)
    }
}
