import Foundation
import JKAMP
import JKAShared
import JKAMP_CGame
import JKAMP_BG

/**
```
-------------------------
FX_ForceDrained
-------------------------
```
*/
// This effect is not generic because of possible enhancements
/// Source: oracle/codemp/cgame/fx_force.c:11
public func FX_ForceDrained(_ origin: JKAShared.vec3_t, _ dir: inout JKAShared.vec3_t) {
    dir = dir * -1.0
    trap_FX_PlayEffectID(cgs.effects.forceDrained, origin, dir, -1, -1)
}
