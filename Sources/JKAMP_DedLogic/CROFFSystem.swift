import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/**
```
The CROFFSystem object provides all of the functionality of ROFF
	caching, playback, and clean-up, plus some useful debug features.
```
*/
/// Raven's ROFF system, the cache of loaded `.rof` files and the list of entities that play one.
/// One instance exists, `theROFFSystem`, for the server and the client sides.
/// Source: oracle/codemp/qcommon/RoffSystem.h:35
// AI: Raven's destructor at RoffSystem.h:162 calls Restart, which frees the cached roffs and resets mID. The class has no deinit.
final class CROFFSystem {
    /// Source: oracle/codemp/qcommon/RoffSystem.h:45
    // AI: Raven declares a `map <int, CROFF *>`. The type is a Dictionary of the class, and a missing key is Raven's NULL.
    private typealias TROFFList = [Int32: CROFF]
    /// Source: oracle/codemp/qcommon/RoffSystem.h:46
    // AI: Raven declares a `vector <SROFFEntity *>` of records from `new`. The type is an Array of the records.
    private typealias TROFFEntList = [SROFFEntity]

    private var mROFFList: TROFFList = [:]				// List of cached roffs
    private var mID: Int32 = 0					// unique ID generator for new roff objects

    private var mROFFEntList: TROFFEntList = []			// List of roffing entities

    /**
    ```
    ROFF Header file definition, nothing else needs to see this
    ```
    */
    /// Source: oracle/codemp/qcommon/RoffSystem.h:54
    private struct TROFFHeader {
        // AI: Raven declares `char mHeader[4]`. The field is a String.
        var mHeader: String = ""				// should match roff_string defined above
        // AI: Raven declares `long`, 32 bits on Win32 where the exporter wrote the file. The field is Int32, the width of the file.
        var mVersion: Int32 = 0				// version num, supported version defined above
        var mCount: Float = 0					// I think this is a float because of a limitation of the roff exporter
    }

    /**
    ```
    ROFF Entry, nothing else needs to see this
    ```
    */
    /// Source: oracle/codemp/qcommon/RoffSystem.h:64
    private struct TROFFEntry {
        // AI: Raven declares `float mOriginOffset[3]` and `float mRotateOffset[3]`. The fields are vec3_t, the same three floats.
        var mOriginOffset: JKAShared.vec3_t = JKAShared.vec3_t()
        var mRotateOffset: JKAShared.vec3_t = JKAShared.vec3_t()
    }

    /// Source: oracle/codemp/qcommon/RoffSystem.h:71
    private struct TROFF2Header {
        // AI: Raven declares `char mHeader[4]`. The field is a String.
        var mHeader: String = ""				// should match roff_string defined above
        // AI: Raven declares `long`, 32 bits on Win32 where the exporter wrote the file. The field is Int32, the width of the file.
        var mVersion: Int32 = 0				// version num, supported version defined above
        var mCount: Int32 = 0					// I think this is a float because of a limitation of the roff exporter
        var mFrameRate: Int32 = 0				// Frame rate the roff should be played at
        var mNumNotes: Int32 = 0				// number of notes (null terminated strings) after the roff data
    }

    /**
    ```
    ROFF Entry, nothing else needs to see this
    ```
    */
    /// Source: oracle/codemp/qcommon/RoffSystem.h:83
    private struct TROFF2Entry {
        // AI: Raven declares `float mOriginOffset[3]` and `float mRotateOffset[3]`. The fields are vec3_t, the same three floats.
        var mOriginOffset: JKAShared.vec3_t = JKAShared.vec3_t()
        var mRotateOffset: JKAShared.vec3_t = JKAShared.vec3_t()
        var mStartNote: Int32 = 0
        var mNumNotes: Int32 = 0		// note track info
    }

    /**
    ```
    An individual ROFF object,
    	contains actual rotation/offset information
    ```
    */
    /// Source: oracle/codemp/qcommon/RoffSystem.h:94
    // AI: Raven's destructor at RoffSystem.cpp:41 frees mMoveRotateList and mNoteTrackIndexes. The class has no deinit.
    private final class CROFF {
        var mID: Int32 = 0						// id for this roff file
        // AI: Raven declares `char mROFFFilePath[MAX_QPATH]`. The field is a String.
        var mROFFFilePath: String = ""	// roff file path
        var mROFFEntries: Int32 = 0				// count of move/rotate commands
        var mFrameTime: Int32 = 0					// frame rate
        var mLerp: Int32 = 0						// Lerp rate (FPS)
        // AI: Raven holds a `TROFF2Entry *` array from `new []`. The field is an Array.
        var mMoveRotateList: [TROFF2Entry] = []			// move rotate/command list
        var mNumNoteTracks: Int32 = 0
        // AI: Raven holds a `char **` array of note pointers into one block. The field is an Array of String.
        var mNoteTrackIndexes: [String] = []
        var mUsedByClient: Bool = false
        var mUsedByServer: Bool = false

        /// Source: oracle/codemp/qcommon/RoffSystem.h:111
        init() {
            self.mUsedByClient = false
            self.mUsedByServer = false
        }

        /**
        ```
        //---------------------------------------------------------------------------
        // CROFFSystem::CROFF::CROFF
        //	Simple constructor for CROFF object
        //
        // INPUTS:
        //	pass in the filepath and the id of the roff object to create
        //
        // RETURN:
        //	none
        //---------------------------------------------------------------------------
        ```
        */
        /// Source: oracle/codemp/qcommon/RoffSystem.cpp:20
        init(_ file: String, _ id: Int32) {
            // TODO: Port CROFFSystem::CROFF::CROFF
            portMissing("CROFFSystem::CROFF::CROFF", source: "oracle/codemp/qcommon/RoffSystem.cpp:20")
        }
    }

    /**
    ```
    The roff system tracks entities that are
    	roffing, so this is the internal structure
    	that represents these objects.
    ```
    */
    /// Source: oracle/codemp/qcommon/RoffSystem.h:125
    // AI: Raven allocates each record with `new` and passes its pointer. The record is a struct in the Array, and a method that writes it takes it inout.
    private struct SROFFEntity {
        var mEntID: Int32 = 0			// the entity that is currently roffing

        var mROFFID: Int32 = 0		// the roff to be applied to that entity
        var mNextROFFTime: Int32 = 0	// next time we should roff
        var mROFFFrame: Int32 = 0		// current roff frame we are applying

        var mKill: Bool = false			// flag to kill a roffing ent
        var mSignal: Bool = false		// TODO:  Need to implement some sort of signal to Icarus when roff is done.
        var mTranslated: Bool = false	// should this roff be "rotated" to fit the entity's initial position?
        var mIsClient: Bool = false
        var mStartAngles: JKAShared.vec3_t = JKAShared.vec3_t()	// initial angle of the entity
    }

    /// Source: oracle/codemp/qcommon/RoffSystem.h:161
    init() {
        self.mID = 0
        self.mROFFEntList.removeAll()
    }

    /**
    ```
    //---------------------------------------------------------------------------
    // CROFFSystem::IsROFF
    //	Makes sure that the requested file is actually a ROFF
    //
    // INPUTS:
    //	pass in the file data
    //
    // RETURN:
    //	returns test success or failure
    //---------------------------------------------------------------------------
    ```
    */
    /// Source: oracle/codemp/qcommon/RoffSystem.cpp:96
    private func IsROFF(_ data: Slots<JKAShared.byte>) -> Bool {
        // TODO: Port CROFFSystem::IsROFF
        portMissing("CROFFSystem::IsROFF", source: "oracle/codemp/qcommon/RoffSystem.cpp:96")
    }

    /**
    ```
    //---------------------------------------------------------------------------
    // CROFFSystem::InitROFF
    //	Handles stuffing the roff data in the CROFF object
    //
    // INPUTS:
    //	pass in the file data and the object to stuff the data into.
    //
    // RETURN:
    //	returns initialization success or failure
    //---------------------------------------------------------------------------
    ```
    */
    /// Source: oracle/codemp/qcommon/RoffSystem.cpp:135
    private func InitROFF(_ data: Slots<JKAShared.byte>, _ obj: CROFF?) -> Bool {
        // TODO: Port CROFFSystem::InitROFF
        portMissing("CROFFSystem::InitROFF", source: "oracle/codemp/qcommon/RoffSystem.cpp:135")
    }

    /**
    ```
    //---------------------------------------------------------------------------
    // CROFFSystem::InitROFF2
    //	Handles stuffing the roff data in the CROFF object for version 2
    //
    // INPUTS:
    //	pass in the file data and the object to stuff the data into.
    //
    // RETURN:
    //	returns initialization success or failure
    //---------------------------------------------------------------------------
    ```
    */
    /// Source: oracle/codemp/qcommon/RoffSystem.cpp:187
    private func InitROFF2(_ data: Slots<JKAShared.byte>, _ obj: CROFF?) -> Bool {
        // TODO: Port CROFFSystem::InitROFF2
        portMissing("CROFFSystem::InitROFF2", source: "oracle/codemp/qcommon/RoffSystem.cpp:187")
    }

    /**
    ```
    ************************************************************************************************
     * CROFFSystem::FixBadAngles                                                                    *
     *    This function will attempt to fix bad angles (large) that come in from the exporter.      *
     *                                                                                              *
     * Input                                                                                        *
     *    obj: the ROFF object                                                                      *
     *                                                                                              *
     * Output / Return                                                                              *
     *    none                                                                                      *
     *                                                                                              *
     ***********************************************************************************************
    ```
    */
    /// Source: oracle/codemp/qcommon/RoffSystem.cpp:258
    private func FixBadAngles(_ obj: CROFF?) {
        // TODO: Port CROFFSystem::FixBadAngles
        portMissing("CROFFSystem::FixBadAngles", source: "oracle/codemp/qcommon/RoffSystem.cpp:258")
    }

    /// Source: oracle/codemp/qcommon/RoffSystem.h:146
    private func NewID() -> Int32 {
        self.mID += 1
        return self.mID
    }

    /**
    ```
    //---------------------------------------------------------------------------
    // CROFFSystem::ApplyROFF
    //	Does the dirty work of applying the raw ROFF data
    //
    // INPUTS:
    //	The the roff_entity struct and the raw roff data
    //
    // RETURN:
    //	True == success;  False == roff playback complete or failure
    //---------------------------------------------------------------------------
    ```
    */
    /// Source: oracle/codemp/qcommon/RoffSystem.cpp:820
    private func ApplyROFF(_ roff_ent: inout SROFFEntity, _ roff: CROFF?) -> Bool {
        // TODO: Port CROFFSystem::ApplyROFF
        portMissing("CROFFSystem::ApplyROFF", source: "oracle/codemp/qcommon/RoffSystem.cpp:820")
    }

    /**
    ```
    ************************************************************************************************
     * CROFFSystem::ProcessNote                                                                     *
     *    This function will send the note to the client.  It will parse through the note for       *
     *    leading or trailing white space (thus making each line feed a separate function call).    *
     *                                                                                              *
     * Input                                                                                        *
     *    ent: the entity for which the roff is being played                                        *
     *    note: the note that should be passed on                                                   *
     *                                                                                              *
     * Output / Return                                                                              *
     *    none                                                                                      *
     *                                                                                              *
     ***********************************************************************************************
    ```
    */
    /// Source: oracle/codemp/qcommon/RoffSystem.cpp:927
    private func ProcessNote(_ roff_ent: SROFFEntity, _ note: String) {
        // TODO: Port CROFFSystem::ProcessNote
        portMissing("CROFFSystem::ProcessNote", source: "oracle/codemp/qcommon/RoffSystem.cpp:927")
    }

    /**
    ```
    //---------------------------------------------------------------------------
    // CROFFSystem::SetLerp
    //	Helper function to set up a positional or angular interpolation
    //
    // INPUTS:
    //	The entity trajectory field to modify, the interpolation type, the base origin,
    //		and the interpolation start time
    //
    // RETURN:
    //	none
    //---------------------------------------------------------------------------
    ```
    */
    /// Source: oracle/codemp/qcommon/RoffSystem.cpp:1024
    private func SetLerp(_ tr: JKAShared.Trajectory?, _ type: JKAShared.trType_t, _ origin: JKAShared.vec3_t, _ delta: JKAShared.vec3_t, _ time: Int32, _ rate: Int32) {
        // TODO: Port CROFFSystem::SetLerp
        portMissing("CROFFSystem::SetLerp", source: "oracle/codemp/qcommon/RoffSystem.cpp:1024")
    }

    /**
    ```
    //---------------------------------------------------------------------------
    // CROFFSystem::ClearLerp
    //	Helper function to clear a given entities lerp fields
    //
    // INPUTS:
    //	The ID of the entity to clear
    //
    // RETURN:
    //	success or failure of the operation
    //---------------------------------------------------------------------------
    ```
    */
    /// Source: oracle/codemp/qcommon/RoffSystem.cpp:973
    private func ClearLerp(_ roff_ent: SROFFEntity) -> Bool {
        // TODO: Port CROFFSystem::ClearLerp
        portMissing("CROFFSystem::ClearLerp", source: "oracle/codemp/qcommon/RoffSystem.cpp:973")
    }

    /**
    ```
    //---------------------------------------------------------------------------
    // CROFFSystem::Restart
    //	Cleans up the roff system, not sure how useful this really is
    //
    // INPUTS:
    //	none
    //
    // RETURN:
    //	success or failure
    //---------------------------------------------------------------------------
    ```
    */
    /// Source: oracle/codemp/qcommon/RoffSystem.cpp:66
    func Restart() -> Bool {
        // TODO: Port CROFFSystem::Restart
        portMissing("CROFFSystem::Restart", source: "oracle/codemp/qcommon/RoffSystem.cpp:66")
    }

    /**
    ```
    //---------------------------------------------------------------------------
    // CROFFSystem::Cache
    //	Pre-caches roff data to avoid file hits during gameplay.  Disallows
    //		repeated caches of existing roffs.
    //
    // INPUTS:
    //	pass in the filepath of the roff to cache
    //
    // RETURN:
    //	returns ID of the roff, whether its an existing one or new one.
    //---------------------------------------------------------------------------
    ```
    */
    /// Source: oracle/codemp/qcommon/RoffSystem.cpp:298
    func Cache(_ file: String, _ isClient: Bool) -> Int32 {
        // TODO: Port CROFFSystem::Cache
        portMissing("CROFFSystem::Cache", source: "oracle/codemp/qcommon/RoffSystem.cpp:298")
    }

    /**
    ```
    //---------------------------------------------------------------------------
    // CROFFSystem::GetID
    //	Finds the associated (internal) ID of the specified roff file
    //
    // INPUTS:
    //	pass in the roff file path
    //
    // RETURN:
    //	returns ID if there is one, zero if nothing was found
    //---------------------------------------------------------------------------
    ```
    */
    /// Source: oracle/codemp/qcommon/RoffSystem.cpp:378
    func GetID(_ file: String) -> Int32 {
        // TODO: Port CROFFSystem::GetID
        portMissing("CROFFSystem::GetID", source: "oracle/codemp/qcommon/RoffSystem.cpp:378")
    }

    /**
    ```
    //---------------------------------------------------------------------------
    // CROFFSystem::Unload
    //	Removes the roff from the list, deleting it to free up any used resources
    //
    // INPUTS:
    //	pass in the id of the roff to delete, use GetID if you only know the roff
    //		filepath
    //
    // RETURN:
    //	qtrue if item was in the list, qfalse otherwise
    //---------------------------------------------------------------------------
    ```
    */
    /// Source: oracle/codemp/qcommon/RoffSystem.cpp:407
    func Unload(_ id: Int32) -> Bool {
        // TODO: Port CROFFSystem::Unload
        portMissing("CROFFSystem::Unload", source: "oracle/codemp/qcommon/RoffSystem.cpp:407")
    }

    /**
    ```
    //---------------------------------------------------------------------------
    // CROFFSystem::Clean
    //	Cleans out all Roffs, freeing up any used resources
    //
    // INPUTS:
    //	none
    //
    // RETURN:
    //	success of operation
    //---------------------------------------------------------------------------
    ```
    */
    /// Source: oracle/codemp/qcommon/RoffSystem.cpp:453
    func Clean(_ isClient: Bool) -> Bool {
        // TODO: Port CROFFSystem::Clean
        portMissing("CROFFSystem::Clean", source: "oracle/codemp/qcommon/RoffSystem.cpp:453")
    }

    /**
    ```
    //---------------------------------------------------------------------------
    // CROFFSystem::List
    //	Dumps the file path to the current set of cached roffs, for debug purposes
    //
    // INPUTS:
    //	none
    //
    // RETURN:
    //	none
    //---------------------------------------------------------------------------
    ```
    */
    /// Source: oracle/codemp/qcommon/RoffSystem.cpp:522
    func List() {
        // TODO: Port CROFFSystem::List
        portMissing("CROFFSystem::List", source: "oracle/codemp/qcommon/RoffSystem.cpp:522")
    }

    /**
    ```
    //---------------------------------------------------------------------------
    // CROFFSystem::List
    //	Overloaded version of List, dumps the specified roff data to the console
    //
    // INPUTS:
    //	id of roff to display
    //
    // RETURN:
    //	success or failure of operation
    //---------------------------------------------------------------------------
    ```
    */
    /// Source: oracle/codemp/qcommon/RoffSystem.cpp:548
    func List(_ id: Int32) -> Bool {
        // TODO: Port CROFFSystem::List
        portMissing("CROFFSystem::List", source: "oracle/codemp/qcommon/RoffSystem.cpp:548")
    }

    /**
    ```
    //---------------------------------------------------------------------------
    // CROFFSystem::Play
    //	Start roff playback on an entity
    //
    // INPUTS:
    //	the id of the entity that will be roffed
    //	the id of the roff to play
    //
    // RETURN:
    //	success or failure of add operation
    //---------------------------------------------------------------------------
    ```
    */
    /// Source: oracle/codemp/qcommon/RoffSystem.cpp:592
    func Play(_ entID: Int32, _ id: Int32, _ doTranslation: Bool, _ isClient: Bool) -> Bool {
        // TODO: Port CROFFSystem::Play
        portMissing("CROFFSystem::Play", source: "oracle/codemp/qcommon/RoffSystem.cpp:592")
    }

    /**
    ```
    //---------------------------------------------------------------------------
    // CROFFSystem::ListEnts
    //	List all of the ents in the roff system
    //
    // INPUTS:
    //	none
    //
    // RETURN:
    //	none
    //---------------------------------------------------------------------------
    ```
    */
    /// Source: oracle/codemp/qcommon/RoffSystem.cpp:637
    func ListEnts() {
        // TODO: Port CROFFSystem::ListEnts
        portMissing("CROFFSystem::ListEnts", source: "oracle/codemp/qcommon/RoffSystem.cpp:637")
    }

    /**
    ```
    //---------------------------------------------------------------------------
    // CROFFSystem::PurgeEnt
    //	Prematurely purge an entity from the roff system
    //
    // INPUTS:
    //	the id of the entity to purge
    //
    // RETURN:
    //	success or failure of purge operation
    //---------------------------------------------------------------------------
    ```
    */
    /// Source: oracle/codemp/qcommon/RoffSystem.cpp:684
    func PurgeEnt(_ entID: Int32, _ isClient: Bool) -> Bool {
        // TODO: Port CROFFSystem::PurgeEnt
        portMissing("CROFFSystem::PurgeEnt", source: "oracle/codemp/qcommon/RoffSystem.cpp:684")
    }

    /**
    ```
    //---------------------------------------------------------------------------
    // CROFFSystem::PurgeEnt
    //	Prematurely purge an entity from the roff system
    //
    // INPUTS:
    //	the name fo the entity to purge
    //
    // RETURN:
    //	success or failure of purge operation
    //---------------------------------------------------------------------------
    ```
    */
    /// Source: oracle/codemp/qcommon/RoffSystem.cpp:719
    func PurgeEnt(_ name: String) -> Bool {
        // TODO: Port CROFFSystem::PurgeEnt
        portMissing("CROFFSystem::PurgeEnt", source: "oracle/codemp/qcommon/RoffSystem.cpp:719")
    }

    /**
    ```
    //---------------------------------------------------------------------------
    // CROFFSystem::UpdateEntities
    //	Update all of the entities in the system
    //
    // INPUTS:
    //	none
    //
    // RETURN:
    //	none
    //---------------------------------------------------------------------------
    ```
    */
    /// Source: oracle/codemp/qcommon/RoffSystem.cpp:746
    func UpdateEntities(_ isClient: Bool) {
        // TODO: Port CROFFSystem::UpdateEntities
        portMissing("CROFFSystem::UpdateEntities", source: "oracle/codemp/qcommon/RoffSystem.cpp:746")
    }
}
