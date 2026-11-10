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
/// Source: oracle/codemp/botlib/be_ai_gen.cpp:75
// AI: Raven declares `rankings` on the stack of GeneticParentsAndChildSelection. The function uses one zeroed allocation on the storage class.
var rankings_GeneticParentsAndChildSelection: Slots<Float> { world.storage.rankings_GeneticParentsAndChildSelection }

/// Source: oracle/codemp/botlib/be_ai_gen.cpp:73
func GeneticParentsAndChildSelection(_ numranks: Int32, _ ranks: Slots<Float>, _ parent1: inout Int32, _ parent2: inout Int32, _ child: inout Int32) -> Int32 {
    var max: Float
    var i: Int32

    if numranks > 256 {
        botimport.runPrint(PRT_WARNING, "GeneticParentsAndChildSelection: too many bots\n")
        child = 0
        parent2 = child
        parent1 = parent2
        return qfalse
    }
    max = 0
    i = 0
    while i < numranks {
        if ranks[i] < 0 {
            i += 1
            continue
        }
        max += 1
        i += 1
    }
    if max < 3 {
        botimport.runPrint(PRT_WARNING, "GeneticParentsAndChildSelection: too few valid bots\n")
        child = 0
        parent2 = child
        parent1 = parent2
        return qfalse
    }
    Com_Memcpy(rankings_GeneticParentsAndChildSelection, ranks, Int32(Float.byteCount) * numranks)
    //select first parent
    parent1 = GeneticSelection(numranks, rankings_GeneticParentsAndChildSelection)
    rankings_GeneticParentsAndChildSelection[parent1] = -1
    //select second parent
    parent2 = GeneticSelection(numranks, rankings_GeneticParentsAndChildSelection)
    rankings_GeneticParentsAndChildSelection[parent2] = -1
    //reverse the rankings
    max = 0
    i = 0
    while i < numranks {
        if rankings_GeneticParentsAndChildSelection[i] < 0 {
            i += 1
            continue
        }
        if rankings_GeneticParentsAndChildSelection[i] > max { max = rankings_GeneticParentsAndChildSelection[i] }
        i += 1
    }
    i = 0
    while i < numranks {
        if rankings_GeneticParentsAndChildSelection[i] < 0 {
            i += 1
            continue
        }
        rankings_GeneticParentsAndChildSelection[i] = max - rankings_GeneticParentsAndChildSelection[i]
        i += 1
    }
    //select child
    child = GeneticSelection(numranks, rankings_GeneticParentsAndChildSelection)
    return qtrue
}
