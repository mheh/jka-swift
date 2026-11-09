import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/renderer/tr_mesh.cpp:12
func ProjectRadius(_ r: Float, _ location: JKAShared.vec3_t) -> Float {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port ProjectRadius
    portMissing("ProjectRadius", source: "oracle/codemp/renderer/tr_mesh.cpp:12")
}
