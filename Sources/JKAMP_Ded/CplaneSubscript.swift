internal import CJKAMP_Ded
import JKAShared

extension Cplane {
    /// Raven's `box_planes[i]` and `&box_planes[i]` through a `cplane_t *` variable, the plane `i` slots past this one.
    /// Source: oracle/codemp/qcommon/cm_load.cpp:962
    // AI: Raven indexes a `cplane_t *` variable as an array. The subscript gives the view `i` slots past this one, because the generated variable holds one view.
    public subscript(i: some BinaryInteger) -> Cplane {
        Cplane(UnsafeMutableRawPointer(self.handle) + Int(i) * Cplane.stride)
    }
}
