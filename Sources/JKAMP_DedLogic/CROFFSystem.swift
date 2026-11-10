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
            self.mROFFFilePath = file

            self.mID = id
            self.mMoveRotateList = []
            self.mNoteTrackIndexes = []
            self.mUsedByServer = false
            self.mUsedByClient = self.mUsedByServer
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
    // AI: Raven allocates each record with `new` and passes its pointer.
    // The record is a struct in the Array, and a method that writes it takes it inout.
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
        // AI: Raven casts the file bytes to his two header records.
        // The body reads each field at its byte offset in the file, `mVersion` at 4 and `mCount` at 8.
        var hdr = TROFFHeader()
        var hdr2 = TROFF2Header()

        hdr.mVersion = data[int: 4]
        hdr.mCount = data[float: 8]
        hdr2.mCount = data[int: 8]

        // AI: Raven runs strcmp over his 4-byte `mHeader`, which reads on into `mVersion`, so the compare decides by the fifth byte at the latest.
        // The body compares the first five bytes of the file with ROFF_STRING.
        var mHeader = CharBuf(5)
        Com_Memcpy(&mHeader, data, 5)

        if strcmp(mHeader, ROFF_STRING) == 0 { // bad header
            return false
        }

        if hdr.mVersion != ROFF_VERSION && hdr.mVersion != ROFF_NEW_VERSION {	// bad version
            return false
        }

        if hdr.mVersion == ROFF_VERSION && hdr.mCount <= 0.0 {	// bad count
            return false
        }

        if hdr.mVersion == ROFF_NEW_VERSION && hdr2.mCount <= 0 {	// bad count
            return false
        }

        return true
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
        var i: Int32

        // AI: Raven casts the file bytes to his header record.
        // The body reads each field at its byte offset in the file, `mVersion` at 4 and `mCount` at 8.
        var hdr = TROFFHeader()
        hdr.mVersion = data[int: 4]
        hdr.mCount = data[float: 8]

        if hdr.mVersion == ROFF_NEW_VERSION {
            return self.InitROFF2(data, obj)
        }

        obj!.mROFFEntries = Int32(hdr.mCount)
        obj!.mMoveRotateList = Array(repeating: TROFF2Entry(), count: Int(Int32(hdr.mCount)))
        obj!.mFrameTime = 1000 / ROFF_SAMPLE_RATE		// default 10 hz
        obj!.mLerp = ROFF_SAMPLE_RATE
        obj!.mNumNoteTracks = 0
        obj!.mNoteTrackIndexes = []

        // Raven tests the result of `new` for NULL, and an Array is never NULL, so the test and its failure arm drop.
        // Step past the header to get to the goods
        // The entries start after the 12 bytes of the header, and each entry is six floats, 24 bytes.

        // Copy all of the goods into our ROFF cache
        i = 0
        while i < hdr.mCount {
            let roff_data = 12 + i * 24
            obj!.mMoveRotateList[i].mOriginOffset = vec3_t(data[float: roff_data], data[float: roff_data + 4], data[float: roff_data + 8])
            obj!.mMoveRotateList[i].mRotateOffset = vec3_t(data[float: roff_data + 12], data[float: roff_data + 16], data[float: roff_data + 20])
            obj!.mMoveRotateList[i].mStartNote = -1
            obj!.mMoveRotateList[i].mNumNotes = 0
            i += 1
        }

        self.FixBadAngles(obj)

        return true
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
        var i: Int32

        // AI: Raven casts the file bytes to his header record.
        // The body reads each field at its byte offset in the file, from `mVersion` at 4 to `mNumNotes` at 16.
        var hdr = TROFF2Header()
        hdr.mVersion = data[int: 4]
        hdr.mCount = data[int: 8]
        hdr.mFrameRate = data[int: 12]
        hdr.mNumNotes = data[int: 16]

        obj!.mROFFEntries = hdr.mCount
        obj!.mMoveRotateList = Array(repeating: TROFF2Entry(), count: Int(hdr.mCount))
        obj!.mFrameTime = hdr.mFrameRate
        obj!.mLerp = 1000 / hdr.mFrameRate
        obj!.mNumNoteTracks = hdr.mNumNotes

        // Raven tests the result of `new` for NULL, and an Array is never NULL, so the test and its failure arm drop.
        // Step past the header to get to the goods
        // The entries start after the 20 bytes of the header, and each entry is six floats and two ints, 32 bytes.

        // Copy all of the goods into our ROFF cache
        i = 0
        while i < hdr.mCount {
            let roff_data = 20 + i * 32
            obj!.mMoveRotateList[i].mOriginOffset = vec3_t(data[float: roff_data], data[float: roff_data + 4], data[float: roff_data + 8])
            obj!.mMoveRotateList[i].mRotateOffset = vec3_t(data[float: roff_data + 12], data[float: roff_data + 16], data[float: roff_data + 20])
            obj!.mMoveRotateList[i].mStartNote = data[int: roff_data + 24]
            obj!.mMoveRotateList[i].mNumNotes = data[int: roff_data + 28]
            i += 1
        }

        self.FixBadAngles(obj)

        if obj!.mNumNoteTracks != 0 {
            var size: Int32
            var ptr: Int32
            let start = 20 + i * 32

            // AI: Raven walks the note texts in the file bytes with strlen. The body copies the bytes after the entries into a CharBuf,
            // the CharBuf overload of Com_Memcpy, and walks the CharBuf with strlen.
            var notes = CharBuf(Int32(data.count) - start)
            Com_Memcpy(&notes, data.suffix(from: start), Int32(data.count) - start)

            ptr = 0
            size = 0

            i = 0
            while i < obj!.mNumNoteTracks {
                size += strlen(notes[ptr...]) + 1
                ptr += strlen(notes[ptr...]) + 1
                i += 1
            }

            // AI: Raven copies the `size` bytes of the texts into one block and points each index into it. Each index is the String of its text.
            obj!.mNoteTrackIndexes = Array(repeating: "", count: Int(obj!.mNumNoteTracks))
            ptr = 0
            obj!.mNoteTrackIndexes[0] = String(notes[ptr...])

            i = 1
            while i < obj!.mNumNoteTracks {
                ptr += strlen(notes[ptr...]) + 1
                obj!.mNoteTrackIndexes[i] = String(notes[ptr...])
                i += 1
            }
        }

        return true
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
        // Ideally we would fix the ROFF exporter, if that doesn't happen, this may be an adequate solution
        var index: Int32
        var t: Int32

        // Attempt to fix bad angles

        index = 0
        while index < obj!.mROFFEntries {
            t = 0
            while t < 3 {
                if obj!.mMoveRotateList[index].mRotateOffset[t] > 180.0 { // found a bad angle
                    //	Com_Printf( S_COLOR_YELLOW"Fixing bad roff angle\n <%6.2f> changed to <%6.2f>.\n",
                    //				roff_data[i].mRotateOffset[t], roff_data[i].mRotateOffset[t] - 360.0f );
                    obj!.mMoveRotateList[index].mRotateOffset[t] -= 360.0
                } else if obj!.mMoveRotateList[index].mRotateOffset[t] < -180.0 { // found a bad angle
                    //	Com_Printf( S_COLOR_YELLOW"Fixing bad roff angle\n <%6.2f> changed to <%6.2f>.\n",
                    //				roff_data[i].mRotateOffset[t], roff_data[i].mRotateOffset[t] + 360.0f );
                    obj!.mMoveRotateList[index].mRotateOffset[t] += 360.0
                }
                t += 1
            }
            index += 1
        }
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
        var f = vec3_t()
        var r = vec3_t()
        var u = vec3_t()
        var result = vec3_t()
        var ent: JKAMP.SharedEntity? = nil
        let originTrajectory: JKAShared.Trajectory
        let angleTrajectory: JKAShared.Trajectory
        let origin: JKAShared.vec3_t
        let angle: JKAShared.vec3_t

        if svs.time < roff_ent.mNextROFFTime { // Not time to roff yet
            return true
        }

        if roff_ent.mIsClient {
            // Port-note: The dedicated build drops Raven's client arm, so the trajectories stay uninitialized and SetLerp reads them.
            // No caller of WinDed sets mIsClient, because sv_game.cpp:725 passes qfalse and WinDed does not link cl_cgame.cpp:1279.
            portMissing("CROFFSystem::ApplyROFF", source: "oracle/codemp/qcommon/RoffSystem.cpp:820")
        } else {
            // Find the entity to apply the roff to
            ent = SV_GentityNum(roff_ent.mEntID)

            if ent == nil {	// bad stuff
                return false
            }

            originTrajectory = ent!.s.pos
            angleTrajectory = ent!.s.apos
            origin = ent!.r.currentOrigin
            angle = ent!.r.currentAngles
        }

        if roff_ent.mROFFFrame >= roff!.mROFFEntries { // we are done roffing, so stop moving and flag this ent to be removed
            self.SetLerp(originTrajectory, TR_STATIONARY, origin, nil, svs.time, roff!.mLerp)
            self.SetLerp(angleTrajectory, TR_STATIONARY, angle, nil, svs.time, roff!.mLerp)
            if !roff_ent.mIsClient {
                ent!.r.mIsRoffing = false
            }
            return false
        }

        if roff_ent.mTranslated {
            AngleVectors(roff_ent.mStartAngles, &f, &r, &u)
            result = f * roff!.mMoveRotateList[roff_ent.mROFFFrame].mOriginOffset[0]
            _VectorMA(result, -roff!.mMoveRotateList[roff_ent.mROFFFrame].mOriginOffset[1], r, &result)
            _VectorMA(result, roff!.mMoveRotateList[roff_ent.mROFFFrame].mOriginOffset[2], u, &result)
        } else {
            result = roff!.mMoveRotateList[roff_ent.mROFFFrame].mOriginOffset
        }

        // Set up our origin interpolation
        self.SetLerp(originTrajectory, TR_LINEAR, origin, result, svs.time, roff!.mLerp)

        // Set up our angle interpolation
        self.SetLerp(angleTrajectory, TR_LINEAR, angle,
                     roff!.mMoveRotateList[roff_ent.mROFFFrame].mRotateOffset, svs.time, roff!.mLerp)

        if roff!.mMoveRotateList[roff_ent.mROFFFrame].mStartNote >= 0 {
            var i: Int32

            i = 0
            while i < roff!.mMoveRotateList[roff_ent.mROFFFrame].mNumNotes {
                self.ProcessNote(roff_ent, roff!.mNoteTrackIndexes[roff!.mMoveRotateList[roff_ent.mROFFFrame].mStartNote + i])
                i += 1
            }
        }

        // Advance ROFF frames and lock to a 10hz cycle
        roff_ent.mROFFFrame += 1
        roff_ent.mNextROFFTime = svs.time + roff!.mFrameTime

        //rww - npcs need to know when they're getting roff'd
        ent!.next_roff_time = roff_ent.mNextROFFTime

        return true
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
        // Raven walks his `note` parameter by byte, so the body walks a CharBuf of it.
        let note = CharBuf(note)
        var temp = CharBuf(1024)
        var pos: Int32
        var size: Int32

        pos = 0
        while note[pos] != 0 {
            size = 0
            while note[pos] != 0 && note[pos] < Int32(ascii: " ") {
                pos += 1
            }

            while note[pos] != 0 && note[pos] >= Int32(ascii: " ") {
                temp[size] = note[pos]
                size += 1
                pos += 1
            }
            temp[size] = 0

            if size != 0 {
                if roff_ent.mIsClient {
                } else {
                    // AI: Raven passes the address of the caller's text. The word holds the address of the buffer for the call, and the module only reads it.
                    withTextWord(temp) { text in
                        VM_Call(gvm!, GAME_ROFF_NOTETRACK_CALLBACK, roff_ent.mEntID, text)
                    }
                }
            }
        }
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
    // AI: Raven's `vec3_t delta` is a pointer that a caller passes as NULL. The parameter is `vec3_t?`, the form of the mins and maxs of SV_Trace.
    private func SetLerp(_ tr: JKAShared.Trajectory?, _ type: JKAShared.trType_t, _ origin: JKAShared.vec3_t, _ delta: JKAShared.vec3_t?, _ time: Int32, _ rate: Int32) {
        tr!.trType = type
        tr!.trTime = time
        tr!.trBase = origin

        // Check for a NULL delta
        if delta != nil {
            tr!.trDelta = delta! * Float(rate)
        } else {
            tr!.trDelta = vec3_t()
        }
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
        let ent: JKAMP.SharedEntity?
        let originTrajectory: JKAShared.Trajectory
        let angleTrajectory: JKAShared.Trajectory
        let origin: JKAShared.vec3_t
        let angle: JKAShared.vec3_t

        if roff_ent.mIsClient {
            // Port-note: The dedicated build drops Raven's client arm, so the trajectories stay uninitialized and SetLerp reads them.
            // No caller of WinDed sets mIsClient, because sv_game.cpp:725 passes qfalse and WinDed does not link cl_cgame.cpp:1279.
            portMissing("CROFFSystem::ClearLerp", source: "oracle/codemp/qcommon/RoffSystem.cpp:973")
        } else {
            // Find the entity to apply the roff to
            ent = SV_GentityNum(roff_ent.mEntID)

            if ent == nil {	// bad stuff
                return false
            }

            originTrajectory = ent!.s.pos
            angleTrajectory = ent!.s.apos
            origin = ent!.r.currentOrigin
            angle = ent!.r.currentAngles
        }

        self.SetLerp(originTrajectory, TR_STATIONARY, origin, nil, svs.time, ROFF_SAMPLE_RATE)
        self.SetLerp(angleTrajectory, TR_STATIONARY, angle, nil, svs.time, ROFF_SAMPLE_RATE)

        return true
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
        // remove everything from the list
        // AI: Raven deletes and erases each roff in a loop. Emptying the Dictionary frees them.
        self.mROFFList.removeAll()

        // clear CROFFSystem unique ID counter
        self.mID = 0

        return true
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
    @discardableResult
    func Cache(_ file: String, _ isClient: Bool) -> Int32 {
        // See if this item is already cached
        var len: Int32
        var id = self.GetID(file)
        var data: Slots<JKAShared.byte>
        var cROFF: CROFF?

        if id != 0 {
        } else { // Read the file in one fell swoop
            var block: OpaquePointer? = nil
            len = FS_ReadFile(file, &block)

            if len <= 0 {
                var otherPath = CharBuf(1024)
                COM_StripExtension(file, &otherPath)
                len = FS_ReadFile(va("scripts/%s.rof", otherPath), &block)
                if len <= 0 {
                    Com_Printf(S_COLOR_RED + "Could not open .ROF file '%s'\n", file)
                    return 0
                }
            }
            // AI: Raven reads the `unsigned char *` of the block.
            // The body reads a Slots over the `len` bytes and the NUL that FS_ReadFile puts after them.
            data = ZipBackend.bytes(block, count: len + 1)!

            // Make sure that the file is roff
            if !self.IsROFF(data) {
                Com_Printf(S_COLOR_RED + "cache failed: roff <%s> does not exist or is not a valid roff\n", file)
                FS_FreeFile(data)

                return 0
            }

            // Things are looking good so far, so create a new CROFF object
            id = self.NewID()

            cROFF = CROFF(file, id)

            self.mROFFList[id] = cROFF

            if !self.InitROFF(data, cROFF) { // something failed, so get rid of the object
                _ = self.Unload(id)
                id = 0
            }

            FS_FreeFile(data)
        }

        // Port-note: Raven reads the end iterator when InitROFF fails, which is undefined. The force unwrap traps there.
        cROFF = self.mROFFList[id]!
        if isClient {
            cROFF!.mUsedByClient = true
        } else {
            cROFF!.mUsedByServer = true
        }

        // If we haven't requested a new ID, we'll just be returning the ID of the existing roff
        return id
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
        // Attempt to find the requested roff
        // AI: Raven walks his `map` in key order. The body walks the sorted keys of the Dictionary.
        for itr in self.mROFFList.keys.sorted() {
            if self.mROFFList[itr]!.mROFFFilePath == file { // return the ID to this roff
                return itr
            }
        }

        // Not found
        return 0
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
        if self.mROFFList[id] != nil { // requested item found in the list, free mem, then remove from list
            self.mROFFList.removeValue(forKey: id)

            return true
        } else { // not found
            return false
        }
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
        // Raven's smallest key is the `begin()` of his ordered map.
        while let itr = self.mROFFList.keys.min() {
            _ = self.Unload(itr)
        }
        return true
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
        Com_Printf(S_COLOR_GREEN + "\n--Cached ROFF files--\n")
        Com_Printf(S_COLOR_GREEN + "ID   FILE\n")

        // AI: Raven walks his `map` in key order. The body walks the sorted keys of the Dictionary.
        for itr in self.mROFFList.keys.sorted() {
            Com_Printf(S_COLOR_GREEN + "%2i - %s\n", itr, self.mROFFList[itr]!.mROFFFilePath)
        }

        Com_Printf(S_COLOR_GREEN + "\nFiles: %i\n", Int32(self.mROFFList.count))
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
        if let obj = self.mROFFList[id] { // requested item found in the list
            let dat = obj.mMoveRotateList

            Com_Printf(S_COLOR_GREEN + "File: %s\n", obj.mROFFFilePath)
            Com_Printf(S_COLOR_GREEN + "ID: %i\n", id)
            Com_Printf(S_COLOR_GREEN + "Entries: %i\n\n", obj.mROFFEntries)

            Com_Printf(S_COLOR_GREEN + "MOVE                 ROTATE\n")

            var i: Int32 = 0
            while i < obj.mROFFEntries {
                Com_Printf(S_COLOR_GREEN + "%6.2f %6.2f %6.2f   %6.2f %6.2f %6.2f\n",
                           dat[i].mOriginOffset[0], dat[i].mOriginOffset[1], dat[i].mOriginOffset[2],
                           dat[i].mRotateOffset[0], dat[i].mRotateOffset[1], dat[i].mRotateOffset[2])
                i += 1
            }

            return true
        }

        Com_Printf(S_COLOR_YELLOW + "ROFF not found: id <%d>\n", id)

        return false
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
        let ent = SV_GentityNum(entID)

        ent!.r.mIsRoffing = true
        /*rjr	if(ent->GetPhysics() == PHYSICS_TYPE_NONE)
        {
            ent->SetPhysics(PHYSICS_TYPE_BRUSHMODEL);
        }*/
        //bjg TODO: reset this latter?

        if ent == nil { // shame on you..
            return false
        }

        var roffing_ent = SROFFEntity()

        roffing_ent.mEntID = entID
        roffing_ent.mROFFID = id
        roffing_ent.mNextROFFTime = svs.time
        roffing_ent.mROFFFrame = 0
        roffing_ent.mKill = false
        roffing_ent.mSignal = true // TODO: hook up the real signal code
        roffing_ent.mTranslated = doTranslation
        roffing_ent.mIsClient = isClient

        roffing_ent.mStartAngles = ent!.s.apos.trBase

        self.mROFFEntList.append(roffing_ent)

        return true
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
        /*	char	*name, *file;
        int		id;

        TROFFEntList::iterator itr = mROFFEntList.begin();
        TROFFList::iterator itrRoff;

        Com_Printf( S_COLOR_GREEN"\n--ROFFing Entities--\n" );
        Com_Printf( S_COLOR_GREEN"EntID EntName       RoffFile\n" );

        // display everything in the end list
        for ( itr = mROFFEntList.begin(); itr != mROFFEntList.end(); ++itr )
        {
            // Entity ID
            id = ((SROFFEntity *)(*itr))->mEntID;
            // Entity Name
            name = entitySystem->GetEntityFromID( id )->GetName();
            // ROFF object that will contain the roff file name
            itrRoff = mROFFList.find( ((SROFFEntity *)(*itr))->mROFFID );

            if ( itrRoff != mROFFList.end() )
            { // grab our filename
                file = ((CROFF *)((*itrRoff).second ))->mROFFFilePath;
            }
            else
            { // roff filename not found == bad
                file = "Error:  Unknown";
            }

            Com_Printf( S_COLOR_GREEN"%3i  %s    %s\n", id, name, file );
        }

        Com_Printf( S_COLOR_GREEN"\nEntities: %i\n", mROFFEntList.size() );*/
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
        for itr in self.mROFFEntList.indices {
            if self.mROFFEntList[itr].mIsClient == isClient && self.mROFFEntList[itr].mEntID == entID {
                // Make sure it won't stay lerping
                _ = self.ClearLerp(self.mROFFEntList[itr])

                self.mROFFEntList.remove(at: itr)
                return true
            }
        }

        Com_Printf(S_COLOR_RED + "Purge failed:  Entity <%i> not found\n", entID)

        return false
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
        /* rjr	CEntity *ent = entitySystem->GetEntityFromName( NULL, name );

        if ( ent && ent->GetInUse() == qtrue )
        {
            return PurgeEnt( ent->GetID() );
        }
        else
        {
            Com_Printf( S_COLOR_RED"Entity <%s> not found or not in use\n", name );
            return qfalse;
        }*/

        return false
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
        var itr: Int

        // display everything in the entity list
        itr = 0
        while itr < self.mROFFEntList.count {
            if self.mROFFEntList[itr].mIsClient != isClient {
                itr += 1
                continue
            }

            // Get this entities ROFF object
            let itrRoff = self.mROFFList[self.mROFFEntList[itr].mROFFID]

            if itrRoff != nil { // roff that baby!
                if !self.ApplyROFF(&self.mROFFEntList[itr], itrRoff) { // done roffing, mark for death
                    self.mROFFEntList[itr].mKill = true
                }
            } else { // roff not found == bad, dump an error message and purge this ent
                Com_Printf(S_COLOR_RED + "ROFF System Error:\n")
                //			Com_Printf( S_COLOR_RED" -ROFF not found for entity <%s>\n",
                //					entitySystem->GetEntityFromID(((SROFFEntity *)(*itr))->mEntID)->GetName() );

                self.mROFFEntList[itr].mKill = true

                _ = self.ClearLerp(self.mROFFEntList[itr])
            }
            itr += 1
        }

        itr = 0

        // Delete killed ROFFers from the list
        // Man, there just has to be a better way to do this
        while itr < self.mROFFEntList.count {
            if self.mROFFEntList[itr].mIsClient != isClient {
                itr += 1
                continue
            }

            if self.mROFFEntList[itr].mKill == true {
                //make sure ICARUS knows ROFF is stopped
                //			CICARUSGameInterface::TaskIDComplete(
                //				entitySystem->GetEntityFromID(((SROFFEntity *)(*itr))->mEntID), TID_MOVE);
                // trash this guy from the list
                self.mROFFEntList.remove(at: itr)
                itr = 0
            } else {
                itr += 1
            }
        }
    }
}
