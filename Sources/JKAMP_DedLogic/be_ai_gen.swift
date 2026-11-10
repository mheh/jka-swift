import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_gen.cpp:35
func GeneticSelection(_ numranks: Int32, _ rankings: Slots<Float>) -> Int32 {
    var sum: Float, select: Float
    var i: Int32, index: Int32

    sum = 0
    i = 0
    while i < numranks {
        if rankings[i] < 0 {
            i += 1
            continue
        }
        sum += rankings[i]
        i += 1
    }
    if sum > 0 {
        //select a bot where the ones with the higest rankings have
        //the highest chance of being selected
        select = random() * sum
        i = 0
        while i < numranks {
            if rankings[i] < 0 {
                i += 1
                continue
            }
            sum -= rankings[i]
            if sum <= 0 { return i }
            i += 1
        }
    }
    //select a bot randomly
    index = Int32(random() * numranks)
    i = 0
    while i < numranks {
        if rankings[index] >= 0 { return index }
        index = (index + 1) % numranks
        i += 1
    }
    return 0
}

//===========================================================================
//
// Parameter:			-
// Returns:				-
// Changes Globals:		-
//===========================================================================
/// Source: oracle/codemp/botlib/be_ai_gen.cpp:73
// Port-note: The body calls botimport.Print, and `botlib_import_t botimport` has no form in the host, row B1 of the seventh ledger.
func GeneticParentsAndChildSelection(_ numranks: Int32, _ ranks: Slots<Float>, _ parent1: inout Int32, _ parent2: inout Int32, _ child: inout Int32) -> Int32 {
    // TODO: Port GeneticParentsAndChildSelection
    portMissing("GeneticParentsAndChildSelection", source: "oracle/codemp/botlib/be_ai_gen.cpp:73")
}
