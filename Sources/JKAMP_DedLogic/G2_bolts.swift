import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

// Given a bone number, see if that bone is already in our bone list
/// Source: oracle/codemp/ghoul2/G2_bolts.cpp:21
func G2_Find_Bolt_Bone_Num(_ bltlist: inout [boltInfo_t], _ boneNum: Int32) -> Int32 {
    var i: Int32

    // look through entire list
    i = 0
    while i < bltlist.count {
        // if this bone entry has no info in it, bounce over it
        if bltlist[i].boneNumber == -1 {
            i += 1
            continue
        }

        if bltlist[i].boneNumber == boneNum {
            return i
        }
        i += 1
    }

    // didn't find it
    return -1
}

// Given a bone number, see if that surface is already in our surfacelist list
/// Source: oracle/codemp/ghoul2/G2_bolts.cpp:45
func G2_Find_Bolt_Surface_Num(_ bltlist: inout [boltInfo_t], _ surfaceNum: Int32, _ flags: Int32) -> Int32 {
    var i: Int32

    // look through entire list
    i = 0
    while i < bltlist.count {
        // if this bone entry has no info in it, bounce over it
        if bltlist[i].surfaceNumber == -1 {
            i += 1
            continue
        }

        if (bltlist[i].surfaceNumber == surfaceNum) && ((bltlist[i].surfaceType & flags) == flags) {
            return i
        }
        i += 1
    }

    // didn't find it
    return -1
}

//=========================================================================================
//// Public Bolt Routines
/// Source: oracle/codemp/ghoul2/G2_bolts.cpp:70
func G2_Add_Bolt_Surf_Num(_ ghlInfo: CGhoul2Info?, _ bltlist: inout [boltInfo_t], _ slist: inout [surfaceInfo_t], _ surfNum: Int32) -> Int32 {
    let tempBolt = boltInfo_t()
    var i: Int32

    // first up, make sure have a surface first
    // AI: Raven compares the signed index with the unsigned size, so a negative index is out of range. The test names that case.
    if surfNum < 0 || surfNum >= slist.count {
        return -1
    }

    // look through entire list - see if it's already there first
    i = 0
    while i < bltlist.count {
        // already there??
        if bltlist[i].surfaceNumber == surfNum {
            // increment the usage count
            bltlist[i].boltUsed += 1
            return i
        }
        i += 1
    }

    // we have a surface
    // look through entire list - see if it's already there first
    i = 0
    while i < bltlist.count {
        // if this surface entry has info in it, bounce over it
        if bltlist[i].boneNumber == -1 && bltlist[i].surfaceNumber == -1 {
            // if we found an entry that had a -1 for the bone / surface number, then we hit a surface / bone slot that was empty
            bltlist[i].surfaceNumber = surfNum
            bltlist[i].surfaceType = G2SURFACEFLAG_GENERATED
            bltlist[i].boltUsed = 1
            return i
        }
        i += 1
    }

    // ok, we didn't find an existing surface of that name, or an empty slot. Lets add an entry
    tempBolt.surfaceNumber = surfNum
    tempBolt.surfaceType = G2SURFACEFLAG_GENERATED
    tempBolt.boneNumber = -1
    tempBolt.boltUsed = 1
    bltlist.append(tempBolt)
    return Int32(bltlist.count) - 1

}

/// Source: oracle/codemp/ghoul2/G2_bolts.cpp:119
func G2_Add_Bolt(_ ghlInfo: CGhoul2Info?, _ bltlist: inout [boltInfo_t], _ slist: inout [surfaceInfo_t], _ boneName: String) -> Int32 {
    // TODO: Port G2_Add_Bolt
    portMissing("G2_Add_Bolt", source: "oracle/codemp/ghoul2/G2_bolts.cpp:119")
}

// Given a model handle, and a bone name, we want to remove this bone from the bone override list
/// Source: oracle/codemp/ghoul2/G2_bolts.cpp:236
func G2_Remove_Bolt(_ bltlist: inout [boltInfo_t], _ index: Int32) -> Bool {
    // did we find it?
    if index != -1 {
        bltlist[index].boltUsed -= 1
        if bltlist[index].boltUsed == 0 {
            // set this bone to not used
            bltlist[index].boneNumber = -1
            bltlist[index].surfaceNumber = -1

            var newSize = bltlist.count
            // now look through the list from the back and see if there is a block of -1's we can resize off the end of the list
            var i = bltlist.count - 1
            while i > -1 {
                if (bltlist[i].surfaceNumber == -1) && (bltlist[i].boneNumber == -1) {
                    newSize = i
                }
                // once we hit one that isn't a -1, we are done.
                else {
                    break
                }
                i -= 1
            }
            // do we need to resize?
            if newSize != bltlist.count {
                // yes, so lets do it
                bltlist.removeLast(bltlist.count - newSize)
            }

        }
        return true
    }

    // no
    return false
}

// set the bolt list to all unused so the bone transformation routine ignores it.
/// Source: oracle/codemp/ghoul2/G2_bolts.cpp:280
func G2_Init_Bolt_List(_ bltlist: inout [boltInfo_t]) {
    bltlist.removeAll()
}

// remove any bolts that reference original surfaces, generated surfaces, or bones that aren't active anymore
/// Source: oracle/codemp/ghoul2/G2_bolts.cpp:286
func G2_RemoveRedundantBolts(_ bltlist: inout [boltInfo_t], _ slist: inout [surfaceInfo_t], _ activeSurfaces: Slots<Int32>, _ activeBones: Slots<Int32>) {
    // walk the bolt list
    var i: Int32 = 0
    while i < bltlist.count {
        // are we using this bolt?
        if (bltlist[i].surfaceNumber != -1) || (bltlist[i].boneNumber != -1) {
            // is this referenceing a surface?
            if bltlist[i].surfaceNumber != -1 {
                // is this bolt looking at a generated surface?
                if bltlist[i].surfaceType != 0 {
                    // yes, so look for it in the surface list
                    if G2_FindOverrideSurface(bltlist[i].surfaceNumber, &slist) == nil {
                        // no - we want to remove this bolt, regardless of how many people are using it
                        bltlist[i].boltUsed = 1
                        G2_Remove_Bolt(&bltlist, i)
                    }
                }
                // no, it's an original, so look for it in the active surfaces list
                // Port-note: After the removal above, Raven reads `activeSurfaces[-1]`, or reads past the end of the list when the resize dropped the bolt.
                // The block runs only while the bolt is still in the list with a surface, because a second removal changes nothing.
                if i < bltlist.count && bltlist[i].surfaceNumber != -1 {
                    if activeSurfaces[bltlist[i].surfaceNumber] == 0 {
                        // no - we want to remove this bolt, regardless of how many people are using it
                        bltlist[i].boltUsed = 1
                        G2_Remove_Bolt(&bltlist, i)
                    }
                }
            }
            // no, must be looking at a bone then
            else {
                // is that bone active then?
                if activeBones[bltlist[i].boneNumber] == 0 {
                    // no - we want to remove this bolt, regardless of how many people are using it
                    bltlist[i].boltUsed = 1
                    G2_Remove_Bolt(&bltlist, i)
                }
            }
        }
        i += 1
    }
}
