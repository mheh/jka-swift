import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Raven's objective of a random mission, with its priority, its state, and the texts the mission prints.
/// The mission holds its objectives, and `CRMManager.mCurObjective` points at the current one.
/// Source: oracle/codemp/RMG/RM_Objective.h:9
// AI: Raven's destructor at RM_Objective.h:27 has an empty body. The class has no deinit.
final class CRMObjective {
    private var mCompleted: Bool = false		// Is objective completed?
    private var mActive: Bool = false		// set to false if the objective requires another objective to be met first
    private var mPriority: Int32 = 0		// sequence in which objectives need to be completed
    private var mOrderIndex: Int32 = 0	// objective index in ui
    private var mCompleteSoundID: Int32 = 0 // sound for when objective is finished
    // AI: Raven declares each text a `std::string`. Each field is a String, rule 17.
    private var mMessage: String = ""		// message outputed when objective is completed
    private var mDescription: String = ""	// description of objective
    private var mInfo: String = ""			// more info for objective
    private var mName: String = ""			// name of objective
    private var mTrigger: String = ""		// trigger associated with objective

    /**
    ```
    ************************************************************************************************
     * CRMObjective::CRMObjective
     *	Constructs a random mission objective and fills in the default properties
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
    /// Source: oracle/codemp/RMG/RM_Objective.cpp:26
    init(_ group: CGPGroup?) {
        self.SetPriority(atoi(group!.FindPairValue("priority", "0")!))
        self.SetMessage(group!.FindPairValue("message", va("Objective %i Completed", self.GetPriority()))!)
        self.SetDescription(group!.FindPairValue("description", va("Objective %i", self.GetPriority()))!)
        self.SetInfo(group!.FindPairValue("info", va("Info %i", self.GetPriority()))!)
        self.SetTrigger(group!.FindPairValue("trigger", "")!)
        self.SetName(group!.GetName())

        /*	const char * soundPath = group->FindPairValue("completed_sound", "" );
        	if (soundPath)
        		mCompleteSoundID = G_SoundIndex(soundPath);
        */

        self.mCompleted = false
        self.mOrderIndex = -1

        // If no priority was specified for this objective then its active by default.
        if self.GetPriority() != 0 {
            self.mActive = false
        } else {
            self.mActive = true
        }
    }

    /**
    ```
    ************************************************************************************************
     * CRMObjective::Link
     *	Links the objective into the world using the current state of the world to determine
     *  where it should link
     *
     * inputs:
     *  none
     *
     * return:
     *	true: objective successfully linked
     *  false: objective failed to link
     *
     ************************************************************************************************
    ```
    */
    /// Source: oracle/codemp/RMG/RM_Objective.cpp:122
    func Link() -> Bool {
        /*	CTriggerAriocheObjective* trigger;

        	// Look for a random trigger to associate this objective to.
        	trigger = FindRandomTrigger ( );
        	if ( NULL != trigger )
        	{
        		trigger->SetObjective ( this );
        	}
        */
        return true
    }

    /// Source: oracle/codemp/RMG/RM_Objective.h:31
    func IsCompleted() -> Bool {
        self.mCompleted
    }

    /// Source: oracle/codemp/RMG/RM_Objective.h:32
    func IsActive() -> Bool {
        self.mActive
    }

    /// Source: oracle/codemp/RMG/RM_Objective.h:38
    func GetPriority() -> Int32 {
        self.mPriority
    }

    /// Source: oracle/codemp/RMG/RM_Objective.h:39
    func GetOrderIndex() -> Int32 {
        self.mOrderIndex
    }

    /// Source: oracle/codemp/RMG/RM_Objective.h:40
    func GetMessage() -> String {
        self.mMessage
    }

    /// Source: oracle/codemp/RMG/RM_Objective.h:41
    func GetDescription() -> String {
        self.mDescription
    }

    /// Source: oracle/codemp/RMG/RM_Objective.h:42
    func GetInfo() -> String {
        self.mInfo
    }

    /// Source: oracle/codemp/RMG/RM_Objective.h:43
    func GetName() -> String {
        self.mName
    }

    /// Source: oracle/codemp/RMG/RM_Objective.h:44
    func GetTrigger() -> String {
        self.mTrigger
    }

    /// Source: oracle/codemp/RMG/RM_Objective.h:45
    func CompleteSoundID() -> Int32 {
        self.mCompleteSoundID
    }

    /// Source: oracle/codemp/RMG/RM_Objective.h:34
    func Activate() {
        self.mActive = true
    }

    /// Source: oracle/codemp/RMG/RM_Objective.h:35
    func Complete(_ comp: Bool) {
        self.mCompleted = comp
    }

    /// Source: oracle/codemp/RMG/RM_Objective.h:48
    func SetPriority(_ priority: Int32) {
        self.mPriority = priority
    }

    /// Source: oracle/codemp/RMG/RM_Objective.h:49
    func SetOrderIndex(_ order: Int32) {
        self.mOrderIndex = order
    }

    /// Source: oracle/codemp/RMG/RM_Objective.h:50
    func SetMessage(_ msg: String) {
        self.mMessage = msg
    }

    /// Source: oracle/codemp/RMG/RM_Objective.h:51
    func SetDescription(_ desc: String) {
        self.mDescription = desc
    }

    /// Source: oracle/codemp/RMG/RM_Objective.h:52
    func SetInfo(_ info: String) {
        self.mInfo = info
    }

    /// Source: oracle/codemp/RMG/RM_Objective.h:53
    func SetName(_ name: String) {
        self.mName = name
    }

    /// Source: oracle/codemp/RMG/RM_Objective.h:54
    func SetTrigger(_ name: String) {
        self.mTrigger = name
    }
}
